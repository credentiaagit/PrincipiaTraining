#!/bin/bash
################################################################################
# Script: 02-data-validation.sh
# Purpose: Validate market data files before processing
# Author: Training Team
# Usage: ./02-data-validation.sh <data_file>
################################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
MIN_FILE_SIZE=1000  # Minimum file size in bytes
REQUIRED_FIELDS=5   # Expected number of fields per line

################################################################################
# Function: print_header
# Purpose: Print formatted header
################################################################################
print_header() {
    echo "========================================="
    echo "Market Data File Validator"
    echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================="
}

################################################################################
# Function: validate_file_exists
# Purpose: Check if file exists and is readable
################################################################################
validate_file_exists() {
    local file=$1
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}ERROR: File '$file' does not exist${NC}"
        return 1
    fi
    
    if [ ! -r "$file" ]; then
        echo -e "${RED}ERROR: File '$file' is not readable${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✓ File exists and is readable${NC}"
    return 0
}

################################################################################
# Function: validate_file_size
# Purpose: Check if file size is within acceptable range
################################################################################
validate_file_size() {
    local file=$1
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    
    if [ $size -lt $MIN_FILE_SIZE ]; then
        echo -e "${RED}ERROR: File size ($size bytes) is below minimum ($MIN_FILE_SIZE bytes)${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✓ File size is acceptable: $size bytes${NC}"
    return 0
}

################################################################################
# Function: validate_file_format
# Purpose: Check CSV format and field count
################################################################################
validate_file_format() {
    local file=$1
    local line_num=0
    local errors=0
    
    echo "Validating file format..."
    
    while IFS= read -r line; do
        ((line_num++))
        
        # Skip empty lines
        [ -z "$line" ] && continue
        
        # Count fields (comma-separated)
        field_count=$(echo "$line" | awk -F',' '{print NF}')
        
        if [ $field_count -ne $REQUIRED_FIELDS ]; then
            echo -e "${YELLOW}WARNING: Line $line_num has $field_count fields (expected $REQUIRED_FIELDS)${NC}"
            ((errors++))
        fi
        
        # Stop after checking first 100 lines to avoid long processing
        [ $line_num -ge 100 ] && break
    done < "$file"
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✓ File format is valid (checked $line_num lines)${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Found $errors format issues in first $line_num lines${NC}"
        return 1
    fi
}

################################################################################
# Function: validate_data_types
# Purpose: Validate data types in critical fields
################################################################################
validate_data_types() {
    local file=$1
    local line_num=0
    local errors=0
    
    echo "Validating data types..."
    
    while IFS=',' read -r trade_id symbol price quantity timestamp; do
        ((line_num++))
        
        # Skip header if present
        [ "$trade_id" == "TRADE_ID" ] && continue
        
        # Validate trade_id (should be numeric or alphanumeric)
        if [[ ! "$trade_id" =~ ^[A-Za-z0-9]+$ ]]; then
            echo -e "${YELLOW}WARNING: Line $line_num - Invalid trade_id: '$trade_id'${NC}"
            ((errors++))
        fi
        
        # Validate price (should be numeric with optional decimal)
        if [[ ! "$price" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            echo -e "${YELLOW}WARNING: Line $line_num - Invalid price: '$price'${NC}"
            ((errors++))
        fi
        
        # Validate quantity (should be integer)
        if [[ ! "$quantity" =~ ^[0-9]+$ ]]; then
            echo -e "${YELLOW}WARNING: Line $line_num - Invalid quantity: '$quantity'${NC}"
            ((errors++))
        fi
        
        # Stop after checking 50 lines
        [ $line_num -ge 50 ] && break
    done < "$file"
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✓ Data types are valid (checked $line_num lines)${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Found $errors data type issues in first $line_num lines${NC}"
        return 1
    fi
}

################################################################################
# Function: check_duplicates
# Purpose: Check for duplicate trade IDs
################################################################################
check_duplicates() {
    local file=$1
    
    echo "Checking for duplicate trade IDs..."
    
    # Extract trade IDs and find duplicates
    duplicates=$(cut -d',' -f1 "$file" | sort | uniq -d | head -5)
    
    if [ -z "$duplicates" ]; then
        echo -e "${GREEN}✓ No duplicate trade IDs found${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Found duplicate trade IDs:${NC}"
        echo "$duplicates" | while read -r dup; do
            echo "  - $dup"
        done
        return 1
    fi
}

################################################################################
# Function: generate_report
# Purpose: Generate validation summary report
################################################################################
generate_report() {
    local file=$1
    local total_lines=$(wc -l < "$file")
    local unique_symbols=$(cut -d',' -f2 "$file" | sort -u | wc -l)
    
    echo ""
    echo "========================================="
    echo "Validation Summary"
    echo "========================================="
    echo "File: $file"
    echo "Total lines: $total_lines"
    echo "Unique symbols: $unique_symbols"
    echo "Validation time: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================="
}

################################################################################
# Main Script
################################################################################
main() {
    # Check command line arguments
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <data_file>"
        echo "Example: $0 market_data.csv"
        exit 1
    fi
    
    local data_file=$1
    local validation_passed=true
    
    print_header
    echo ""
    
    # Run all validations
    validate_file_exists "$data_file" || validation_passed=false
    validate_file_size "$data_file" || validation_passed=false
    echo ""
    
    # Only continue with content validation if file exists
    if [ -f "$data_file" ]; then
        validate_file_format "$data_file" || validation_passed=false
        validate_data_types "$data_file" || validation_passed=false
        check_duplicates "$data_file" || validation_passed=false
        
        generate_report "$data_file"
    fi
    
    # Final result
    echo ""
    if [ "$validation_passed" = true ]; then
        echo -e "${GREEN}✓ ALL VALIDATIONS PASSED${NC}"
        exit 0
    else
        echo -e "${RED}✗ VALIDATION FAILED - Please review errors above${NC}"
        exit 1
    fi
}

# Run main function
main "$@"


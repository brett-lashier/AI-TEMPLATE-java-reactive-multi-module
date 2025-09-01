#!/bin/bash

# check-structure.sh - Utility to check existing project structure for Java reactive multi-module project
# Usage: ./check-structure.sh [product] [feature]

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_header() { echo -e "${CYAN}[HEADER]${NC} $1"; }

# Function to show usage
usage() {
    echo "Usage: $0 [product] [feature]"
    echo ""
    echo "Arguments (optional):"
    echo "  product         Check specific product structure"
    echo "  feature         Check specific feature structure (requires product)"
    echo ""
    echo "Examples:"
    echo "  $0                      # Check overall project structure"
    echo "  $0 user                 # Check user product structure"
    echo "  $0 user registration    # Check user registration feature structure"
    exit 1
}

PRODUCT=${1:-""}
FEATURE=${2:-""}

# Validate arguments
if [ -n "$FEATURE" ] && [ -z "$PRODUCT" ]; then
    print_error "Feature specified without product"
    usage
fi

print_header "Java Reactive Multi-Module Project Structure Check"
echo "=================================================="

# Find modules
print_info "Detecting modules..."
API_MODULE=$(find . -maxdepth 1 -type d -name "*-api" | head -1)
REST_MODULE=$(find . -maxdepth 1 -type d -name "*-rest" | head -1)
MODEL_MODULE=$(find . -maxdepth 1 -type d -name "*-model" | head -1)
PARENT_MODULE=$(find . -maxdepth 1 -type d -name "*-parent" | head -1)

echo ""
print_header "Module Detection:"
[ -n "$API_MODULE" ] && print_success "API Module: $API_MODULE" || print_error "API Module: Not found"
[ -n "$REST_MODULE" ] && print_success "REST Module: $REST_MODULE" || print_error "REST Module: Not found"
[ -n "$MODEL_MODULE" ] && print_success "Model Module: $MODEL_MODULE" || print_error "Model Module: Not found"
[ -n "$PARENT_MODULE" ] && print_success "Parent Module: $PARENT_MODULE" || print_error "Parent Module: Not found"

if [ -z "$API_MODULE" ] || [ -z "$REST_MODULE" ]; then
    print_error "Critical modules missing. Cannot continue."
    exit 1
fi

# Extract group ID
EXISTING_JAVA=$(find "$API_MODULE" -name "*.java" | head -1)
if [ -n "$EXISTING_JAVA" ]; then
    GROUP_ID=$(grep -o 'package [^;]*' "$EXISTING_JAVA" | head -1 | sed 's/package //' | cut -d'.' -f1-2)
    print_success "Group ID: $GROUP_ID"
else
    print_warning "Group ID: Could not extract from existing files"
    GROUP_ID=""
fi

# Build base paths
if [ -n "$GROUP_ID" ]; then
    API_BASE_PATH="$API_MODULE/src/main/java/$(echo $GROUP_ID | tr '.' '/')"
    REST_BASE_PATH="$REST_MODULE/src/main/java/$(echo $GROUP_ID | tr '.' '/')"
    [ -n "$MODEL_MODULE" ] && MODEL_BASE_PATH="$MODEL_MODULE/src/main/java/$(echo $GROUP_ID | tr '.' '/')"
fi

echo ""
print_header "Base Package Structure:"
if [ -n "$GROUP_ID" ]; then
    [ -d "$API_BASE_PATH" ] && print_success "API base: $API_BASE_PATH" || print_warning "API base: $API_BASE_PATH (not found)"
    [ -d "$REST_BASE_PATH" ] && print_success "REST base: $REST_BASE_PATH" || print_warning "REST base: $REST_BASE_PATH (not found)"
    [ -n "$MODEL_MODULE" ] && { [ -d "$MODEL_BASE_PATH" ] && print_success "Model base: $MODEL_BASE_PATH" || print_warning "Model base: $MODEL_BASE_PATH (not found)"; }
else
    print_warning "Cannot check base paths without group ID"
fi

# Check specific product/feature if requested
if [ -n "$PRODUCT" ]; then
    echo ""
    print_header "Product Structure Check: $PRODUCT"
    
    if [ -n "$GROUP_ID" ]; then
        API_PRODUCT_PATH="$API_BASE_PATH/$PRODUCT"
        REST_PRODUCT_PATH="$REST_BASE_PATH/$PRODUCT"
        [ -n "$MODEL_MODULE" ] && MODEL_PRODUCT_PATH="$MODEL_BASE_PATH/$PRODUCT"
        
        [ -d "$API_PRODUCT_PATH" ] && print_success "API product: $API_PRODUCT_PATH" || print_warning "API product: $API_PRODUCT_PATH (not found)"
        [ -d "$REST_PRODUCT_PATH" ] && print_success "REST product: $REST_PRODUCT_PATH" || print_warning "REST product: $REST_PRODUCT_PATH (not found)"
        [ -n "$MODEL_MODULE" ] && { [ -d "$MODEL_PRODUCT_PATH" ] && print_success "Model product: $MODEL_PRODUCT_PATH" || print_warning "Model product: $MODEL_PRODUCT_PATH (not found)"; }
        
        if [ -n "$FEATURE" ]; then
            echo ""
            print_header "Feature Structure Check: $PRODUCT/$FEATURE"
            
            API_FEATURE_PATH="$API_PRODUCT_PATH/$FEATURE"
            REST_FEATURE_PATH="$REST_PRODUCT_PATH/$FEATURE"
            REST_CONTROLLER_PATH="$REST_FEATURE_PATH/controller"
            [ -n "$MODEL_MODULE" ] && MODEL_FEATURE_PATH="$MODEL_PRODUCT_PATH/$FEATURE"
            
            [ -d "$API_FEATURE_PATH" ] && print_success "API feature: $API_FEATURE_PATH" || print_warning "API feature: $API_FEATURE_PATH (not found)"
            [ -d "$REST_FEATURE_PATH" ] && print_success "REST feature: $REST_FEATURE_PATH" || print_warning "REST feature: $REST_FEATURE_PATH (not found)"
            [ -d "$REST_CONTROLLER_PATH" ] && print_success "REST controller dir: $REST_CONTROLLER_PATH" || print_warning "REST controller dir: $REST_CONTROLLER_PATH (not found)"
            [ -n "$MODEL_MODULE" ] && { [ -d "$MODEL_FEATURE_PATH" ] && print_success "Model feature: $MODEL_FEATURE_PATH" || print_warning "Model feature: $MODEL_FEATURE_PATH (not found)"; }
            
            # List files in feature directories
            if [ -d "$API_FEATURE_PATH" ]; then
                echo ""
                print_info "API feature files:"
                find "$API_FEATURE_PATH" -name "*.java" -type f | sed 's/^/  /'
            fi
            
            if [ -d "$REST_CONTROLLER_PATH" ]; then
                echo ""
                print_info "REST controller files:"
                find "$REST_CONTROLLER_PATH" -name "*.java" -type f | sed 's/^/  /'
            fi
        fi
    fi
fi

# Overall structure overview
echo ""
print_header "Overall Structure Overview:"

if [ -n "$GROUP_ID" ] && [ -d "$API_BASE_PATH" ]; then
    echo ""
    print_info "API Module Products:"
    find "$API_BASE_PATH" -maxdepth 1 -type d ! -name "$(basename "$API_BASE_PATH")" | sed 's/^/  /' | sed 's/.*\//  - /'
    
    echo ""
    print_info "REST Module Products:"
    if [ -d "$REST_BASE_PATH" ]; then
        find "$REST_BASE_PATH" -maxdepth 1 -type d ! -name "$(basename "$REST_BASE_PATH")" | sed 's/^/  /' | sed 's/.*\//  - /'
    fi
fi

# File counts
echo ""
print_header "File Counts:"
API_JAVA_COUNT=$(find "$API_MODULE" -name "*.java" -type f 2>/dev/null | wc -l)
REST_JAVA_COUNT=$(find "$REST_MODULE" -name "*.java" -type f 2>/dev/null | wc -l)
print_info "API Module Java files: $API_JAVA_COUNT"
print_info "REST Module Java files: $REST_JAVA_COUNT"

if [ -n "$MODEL_MODULE" ]; then
    MODEL_JAVA_COUNT=$(find "$MODEL_MODULE" -name "*.java" -type f 2>/dev/null | wc -l)
    print_info "Model Module Java files: $MODEL_JAVA_COUNT"
fi

echo ""
print_success "Structure check completed!"
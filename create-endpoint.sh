#!/bin/bash

# create-endpoint.sh - Automate REST endpoint creation for Java reactive multi-module project
# Usage: ./create-endpoint.sh <product> <feature> <interface_name> [group_id]

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to show usage
usage() {
    echo "Usage: $0 <product> <feature> <interface_name> [group_id]"
    echo ""
    echo "Arguments:"
    echo "  product         Product/domain name (e.g., user, company, inventory)"
    echo "  feature         Feature name (e.g., registration, dashboard, orders)"
    echo "  interface_name  Interface name for API (e.g., UserRegistrationApi)"
    echo "  group_id        Optional group ID (default: extracted from existing project)"
    echo ""
    echo "Example:"
    echo "  $0 user registration UserRegistrationApi"
    echo "  $0 company dashboard CompanyDashboardApi com.mycompany"
    exit 1
}

# Check arguments
if [ $# -lt 3 ] || [ $# -gt 4 ]; then
    print_error "Invalid number of arguments"
    usage
fi

PRODUCT=$1
FEATURE=$2
INTERFACE_NAME=$3
GROUP_ID=${4:-""}

# Validate product and feature names (lowercase, alphanumeric)
if [[ ! "$PRODUCT" =~ ^[a-z][a-z0-9]*$ ]]; then
    print_error "Product name must start with lowercase letter and contain only lowercase letters and numbers"
    exit 1
fi

if [[ ! "$FEATURE" =~ ^[a-z][a-z0-9]*$ ]]; then
    print_error "Feature name must start with lowercase letter and contain only lowercase letters and numbers"
    exit 1
fi

# Find API and REST modules
API_MODULE=$(find . -maxdepth 1 -type d -name "*-api" | head -1)
REST_MODULE=$(find . -maxdepth 1 -type d -name "*-rest" | head -1)

if [ -z "$API_MODULE" ] || [ -z "$REST_MODULE" ]; then
    print_error "Could not find *-api or *-rest modules in current directory"
    exit 1
fi

print_info "Found modules: API=$API_MODULE, REST=$REST_MODULE"

# Extract group ID if not provided
if [ -z "$GROUP_ID" ]; then
    # Look for existing Java files to extract package structure
    EXISTING_JAVA=$(find "$API_MODULE" -name "*.java" | head -1)
    if [ -n "$EXISTING_JAVA" ]; then
        GROUP_ID=$(grep -o 'package [^;]*' "$EXISTING_JAVA" | head -1 | sed 's/package //' | cut -d'.' -f1-2)
        print_info "Extracted group ID: $GROUP_ID"
    else
        print_error "Could not extract group ID and none provided"
        exit 1
    fi
fi

# Build paths
API_BASE_PATH="$API_MODULE/src/main/java/$(echo $GROUP_ID | tr '.' '/')"
REST_BASE_PATH="$REST_MODULE/src/main/java/$(echo $GROUP_ID | tr '.' '/')"

API_PRODUCT_PATH="$API_BASE_PATH/$PRODUCT"
API_FEATURE_PATH="$API_PRODUCT_PATH/$FEATURE"

REST_PRODUCT_PATH="$REST_BASE_PATH/$PRODUCT"
REST_FEATURE_PATH="$REST_PRODUCT_PATH/$FEATURE"
REST_CONTROLLER_PATH="$REST_FEATURE_PATH/controller"

# Step 1: Check and create product directories
print_info "Step 1: Checking product existence..."

if [ ! -d "$API_PRODUCT_PATH" ]; then
    print_info "Creating product directory in API module: $API_PRODUCT_PATH"
    mkdir -p "$API_PRODUCT_PATH"
    print_success "Created API product directory"
else
    print_info "API product directory already exists"
fi

if [ ! -d "$REST_PRODUCT_PATH" ]; then
    print_info "Creating product directory in REST module: $REST_PRODUCT_PATH"
    mkdir -p "$REST_PRODUCT_PATH"
    print_success "Created REST product directory"
else
    print_info "REST product directory already exists"
fi

# Step 2: Check and create feature directories
print_info "Step 2: Checking feature existence..."

if [ ! -d "$API_FEATURE_PATH" ]; then
    print_info "Creating feature directory in API module: $API_FEATURE_PATH"
    mkdir -p "$API_FEATURE_PATH"
    print_success "Created API feature directory"
else
    print_info "API feature directory already exists"
fi

if [ ! -d "$REST_FEATURE_PATH" ]; then
    print_info "Creating feature directory in REST module: $REST_FEATURE_PATH"
    mkdir -p "$REST_FEATURE_PATH"
    print_success "Created REST feature directory"
fi

# Create controller subdirectory
if [ ! -d "$REST_CONTROLLER_PATH" ]; then
    print_info "Creating controller directory: $REST_CONTROLLER_PATH"
    mkdir -p "$REST_CONTROLLER_PATH"
    print_success "Created REST controller directory"
else
    print_info "REST controller directory already exists"
fi

# Step 3: Create API interface
print_info "Step 3: Creating API interface..."

API_FILE="$API_FEATURE_PATH/${INTERFACE_NAME}.java"
CONTROLLER_FILE="$REST_CONTROLLER_PATH/${INTERFACE_NAME}Controller.java"

if [ -f "$API_FILE" ]; then
    print_warning "API interface already exists: $API_FILE"
else
    cat > "$API_FILE" << EOF
package ${GROUP_ID}.${PRODUCT}.${FEATURE};

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import reactor.core.publisher.Mono;

@RequestMapping("/${PRODUCT}/${FEATURE}")
public interface ${INTERFACE_NAME} {
    
    @GetMapping
    Mono<String> get${FEATURE^}();
}
EOF
    print_success "Created API interface: $API_FILE"
fi

# Step 4: Create REST controller
print_info "Step 4: Creating REST controller..."

if [ -f "$CONTROLLER_FILE" ]; then
    print_warning "Controller already exists: $CONTROLLER_FILE"
else
    cat > "$CONTROLLER_FILE" << EOF
package ${GROUP_ID}.${PRODUCT}.${FEATURE}.controller;

import ${GROUP_ID}.${PRODUCT}.${FEATURE}.${INTERFACE_NAME};
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class ${INTERFACE_NAME}Controller implements ${INTERFACE_NAME} {
    
    @Override
    public Mono<String> get${FEATURE^}() {
        return Mono.just("${FEATURE^} endpoint response");
    }
}
EOF
    print_success "Created REST controller: $CONTROLLER_FILE"
fi

print_success "Endpoint creation completed!"
print_info "Created structure:"
print_info "  API Interface: $API_FILE"
print_info "  REST Controller: $CONTROLLER_FILE"
print_info ""
print_info "Next steps:"
print_info "  1. Customize the API interface with your specific endpoints"
print_info "  2. Implement the controller logic"
print_info "  3. Create service and repository layers as needed"
print_info "  4. Add proper request/response DTOs in the model module"
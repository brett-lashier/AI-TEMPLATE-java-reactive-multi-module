# AI-TEMPLATE-java-reactive-multi-module

> **⚠️ FOR AI AGENTS: Read `.ai-rules` file for concise project rules**  
> **📖 FOR HUMANS: This README contains detailed documentation**

> **⚠️ DISCLAIMER FOR HUMAN READERS**  
> This README provides comprehensive documentation. AI agents should primarily use the `.ai-rules` file for concise, actionable instructions, while referencing this README for detailed explanations.

This is a **Java 21** reactive multi-module project template using Spring WebFlux, Lombok, and Netty (instead of Tomcat) for non-blocking, reactive web applications.

This project is designed for use by AI agents such as Claude Code, Copilot, Cursor, and others. Please read this README to understand the multi-module pattern and how to use or extend this template.

## ⚠️ IMPORTANT INSTRUCTIONS FOR AI/LLM AGENTS ⚠️

**BEFORE proceeding with ANY work on this project, you MUST ask the user these questions:**

1. **What is the project name?** (This will replace all instances of `AI-TEMPLATE` throughout the codebase)
2. **What is the group ID?** (This will replace `com.example` in all package structures)

**CRITICAL REQUIREMENTS:**
1. **Must ask required questions and get answers before generating code** - All mandatory questions above must be answered before any code generation or project modification begins
2. **Do NOT create placeholder folders** - Do **NOT** create any `__PRODUCT__`, `__FEATURE__`, `PRODUCT`, `FEATURE`, `SUBFEATURE` folders or their children folders until explicitly asked to do so by the user. These are only reference placeholders. When the user does ask to generate a new feature, you MUST follow the exact format specified in the Module Structure section below and always ask the user to specify the actual names for `__PRODUCT__`, `__FEATURE__`, and `__SUBFEATURE__` before creating any folders
3. **Create folders only for features, not classes** - Create the folder structure for the requested feature but do NOT create any Classes in `*-rest`, `*-api`, `*-model` modules. The examples in this README are for reference only when actual classes need to be created

**These requirements are mandatory and must be satisfied before any code generation or project modification.**

## Module Structure

### `*-parent`
- Controls dependency versions for all other modules using Maven's `dependencyManagement` tag (NOT `dependencies` tag).
- **Packaging:** `pom`
- Does **not** define modules in its own dependency management.
- Uses `spring-boot-starter-parent` as its parent.
- **MUST use Spring Boot version 3.5.4**
- **IMPORTANT:** Must contain a `<parent>` tag that points to `spring-boot-starter-parent` version 3.5.4
- **IMPORTANT:** Must contain a `<dependencyManagement>` section, not standalone `<dependencies>`.
- **CRITICAL:** Must only use dependencies defined in this template - no additional dependencies allowed.

### `*-api`
- **Packaging:** `jar`
- Contains only a `src` directory for source code and a `pom.xml`.
- May include additional files (e.g., Lombok configuration).
- **Dependencies:** Must use exact dependencies defined in this project's parent module via `dependencyManagement` AND the same dependencies used in this template's `*-api` module with exact versions from parent.
- **Folder Structure:**
  ```
  src/
    main/
      java/
        com/
          example/
            __PRODUCT__/
              __FEATURE__/
                __SUBFEATURE__/
                  [Endpoint interfaces]
  ```
  - Replace `__PRODUCT__` with your product name (e.g., `company`, `user`).
  - Replace `__FEATURE__` with the feature name (e.g., `register`, `dashboard`).
  - Replace `__SUBFEATURE__` with a granular feature (e.g., `dashboard/employees`).
- Each interface used to define an endpoint follows this structure.

### `*-rest`
- **Packaging:** `jar`
- Contains only a `pom.xml` (no other files or directories).
- Should contain an `application-[ENV].yml` file, where `[ENV]` is the name of the profile and environment that needs separate configuration.
- **Dependencies:** Must use exact dependencies defined in this project's parent module via `dependencyManagement` AND the same dependencies used in this template's `*-rest` module with exact versions from parent.
- **Folder Structure (when implemented):**
  ```
  src/
    main/
      java/
        com/
          example/
            __PRODUCT__/
              __FEATURE__/
                controller/
                repository/
                service/
      config/
  ```
  - `controller`: Implementation of interfaces defined in `*-api`.
  - `repository`: `@Repository` interfaces for data persistence.
  - `service`: Business/service logic, may interact with repositories.
  - `config`: Spring configuration files.

### `*-model`
- **Packaging:** `jar`
- **Dependencies:** Must use exact dependencies defined in this project's parent module via `dependencyManagement` AND the same dependencies used in this template's `*-model` module with exact versions from parent.
- **Folder Structure:**
  ```
  src/
    main/
      java/
        com/
          example/
            __PRODUCT__/
              __FEATURE__/
                transporttype/
                  [rest, grpc(proto) request/response objects]
                jpa/
                  [JPA entities]
                [Other simple objects for REST]
  ```
  - Replace `__PRODUCT__` and `__FEATURE__` as above.
  - `transporttype`: Contains files for REST, gRPC, etc.
  - `jpa`: Contains JPA entities.
  - Other types of objects used in REST as simple POJOs.

## Relationships

1. **Parent (`*-parent`)**:  
   - Does **not** define modules in its dependency management.
   - Uses `spring-boot-starter-parent` as its parent.
   - **CRITICAL:** Must use `<dependencyManagement>` tag, NOT `<dependencies>` tag alone.

2. **API (`*-api`)**:  
   - Depends on the model module.
   - Uses the parent module as its parent.
   - **Dependencies:** Must use exact dependencies from parent's `dependencyManagement` with exact versions AND match this template's `*-api` module dependencies exactly.

3. **Model (`*-model`)**:  
   - Does **not** depend on other modules.
   - Uses the parent module as its parent.
   - **Dependencies:** Must use exact dependencies from parent's `dependencyManagement` with exact versions AND match this template's `*-model` module dependencies exactly.

4. **REST (`*-rest`)**:  
   - Depends on the model and API modules (and any other required modules).
   - **Dependencies:** Must use exact dependencies from parent's `dependencyManagement` with exact versions AND match this template's `*-rest` module dependencies exactly.

## Building

Each module contains its own `pom.xml` which defines dependencies, plugins, and build configuration.  
The root `pom.xml` lists all modules and controls the build order.

## Root `pom.xml` Details

- **Packaging:** `pom`
- **SCM:**  
  The `<scm>` section stores information about the GitHub repository:
  ```
  <scm>
      <connection>scm:git:https://github.com/brett-lashier/AI-TEMPLATE-java-reactive-multi-module.git</connection>
      <developerConnection>scm:git@github.com:brett-lashier/AI-TEMPLATE-java-reactive-multi-module.git</developerConnection>
      <url>https://github.com/brett-lashier/AI-TEMPLATE-java-reactive-multi-module</url>
      <tag>HEAD</tag>
  </scm>
  ```

## Customization

Replace `AI-TEMPLATE` with your project name throughout the codebase and documentation.

---

**Pattern Summary:**  
- Use the parent module for dependency management.  
- Define API endpoints as interfaces in the API module.  
- Implement logic and configuration in the REST module.  
- Define all data models in the model module.

---

For further details, see the individual module `pom.xml` files and the root

## AI/LLM Design Rules

When working with this multi-module reactive Java template, follow these rules to maintain consistency and proper architecture:

### ⚠️ CRITICAL: NO ASSUMPTIONS RULE ⚠️
**NEVER NEVER NEVER make assumptions about versions being broken, dependencies needing updates, or changes that should be added.** Use EXACTLY what is specified in this template. Do not suggest version upgrades, dependency additions, or modifications unless explicitly requested by the user. The template versions and dependencies are intentionally chosen and tested.

### Module Creation Rules
1. **Always create 4 modules minimum**: `*-parent`, `*-api`, `*-model`, `*-rest`
2. **Parent module**: Must use `pom` packaging and `spring-boot-starter-parent` as parent
3. **API module**: Must use `jar` packaging, contain only interfaces, depend on model module
4. **Model module**: Must use `jar` packaging, contain only data objects, no external dependencies except parent
5. **REST module**: Must use `jar` packaging, implement API interfaces, depend on both API and model modules

### Package Structure Rules
6. **Use consistent package naming**: `com.example.__PRODUCT__.__FEATURE__.__SUBFEATURE__`
7. **Replace placeholders systematically**: 
   - `__PRODUCT__` = your product domain (e.g., `user`, `company`, `inventory`)
   - `__FEATURE__` = main feature (e.g., `registration`, `dashboard`, `orders`)
   - `__SUBFEATURE__` = granular feature (e.g., `employees`, `reports`)

### File Organization Rules
8. **API module structure**: Only `src/main/java` with interface definitions
9. **Model module structure**: Separate `transporttype` (REST/gRPC objects) from `jpa` (entities)
10. **REST module structure**: Organize by `controller`, `repository`, `service`, `config` packages
11. **Configuration files**: Place `application-[ENV].yml` in REST module resources

### Dependency Rules
12. **Parent defines versions**: All version management in parent module's `<dependencyManagement>` section (NOT `<dependencies>`)
13. **Parent must use Spring 3.5.4**: Parent module must specify exactly Spring Boot version 3.5.4 with proper `<parent>` tag pointing to `spring-boot-starter-parent`
14. **Exact dependencies**: Each module must use the exact dependencies defined in this project's parent `dependencyManagement` with exact versions AND match the corresponding module type in this template (e.g., new `*-rest` modules must use same dependencies as this template's `*-rest` module)
15. **Template compliance**: Parent must only use dependencies defined in this template - no additional dependencies allowed
16. **No circular dependencies**: Model → API → REST (never reverse)
17. **Model isolation**: Model module should not depend on API or REST modules
18. **API purity**: API module contains only interface definitions, no implementations
19. **Annotation placement**: All `*Mapping` annotations (e.g., `@GetMapping`, `@PostMapping`) and `@RequestMapping` must be placed in the interface (API module), not in the controller implementation

### Naming Convention Rules
20. **Module naming**: Use `[project-name]-[module-type]` pattern
21. **Interface naming**: End API interfaces with appropriate suffixes (`Controller`, `Service`, `Repository`)
22. **Class naming**: Implementation classes should clearly indicate their purpose and layer

### Architecture Rules
23. **Separation of concerns**: Keep transport objects separate from JPA entities
24. **Reactive patterns**: Use reactive streams (Mono/Flux) in API definitions when applicable
25. **WebFlux + Netty**: This project uses Spring WebFlux with Netty (not Tomcat) for reactive, non-blocking operations
26. **Configuration centralization**: Environment-specific config in REST module only
27. **Single responsibility**: Each module has one clear purpose and boundary

### Build and Deployment Rules
28. **Root POM management**: List all modules in root `pom.xml` with proper build order
29. **SCM configuration**: Always include proper SCM section in root POM
30. **Profile support**: Use Spring profiles for environment-specific configurations

### Code Quality Rules
31. **No business logic in API**: Keep API module purely declarative
32. **Proper error handling**: Implement consistent error handling patterns across REST implementations
33. **Documentation**: Each interface and major class should have appropriate JavaDoc
34. **Testing strategy**: Unit tests in each module, integration tests in REST module
35. **Mandatory completion test**: After completing ANY project generation or modification, MUST run `mvn clean install` to verify the project builds successfully and follows all README requirements. If the build fails, fix all issues before considering the task complete

### Extension Rules
36. **Adding new features**: Create new packages following the established structure
37. **Cross-cutting concerns**: Handle in REST module configuration, not in API or model
38. **Third-party integrations**: Isolate in REST module, expose through API interfaces only

These rules ensure maintainable, scalable, and properly architected multi-module reactive Java applications that can be easily understood and extended by AI assistants.

## LLM Rules for Adding REST Endpoints

Follow these steps when an LLM/AI agent is asked to create a new REST endpoint:

### Required Information
1. **Product Name** - The domain/product area (e.g., `user`, `company`, `inventory`)
2. **Feature Name** - The specific feature (e.g., `registration`, `dashboard`, `orders`)
3. **Endpoint Details** - HTTP method, path, request/response structure
4. **Interface Name** - If product/feature doesn't exist, ask for the interface name to store in `*-api` module

### Step-by-Step Process

#### Step 1: Check Product Existence
- Search for the product folder in `*-api/src/main/java/com/[groupId]/__PRODUCT__/`
- Search for the product folder in `*-rest/src/main/java/com/[groupId]/__PRODUCT__/`
- If product doesn't exist, create the folder structure in both modules

#### Step 2: Check Feature Existence  
- Search for the feature folder in `*-api/src/main/java/com/[groupId]/__PRODUCT__/__FEATURE__/`
- Search for the feature folder in `*-rest/src/main/java/com/[groupId]/__PRODUCT__/__FEATURE__/`
- If feature doesn't exist, create the folder structure in both modules

#### Step 3: Create API Interface (if needed)
- If PRODUCT/FEATURE folders don't exist in `*-api`, create them
- Ask user for the interface name for REST mapping (e.g., `UserRegistrationApi`)
- Create the interface file in `*-api/src/main/java/com/[groupId]/__PRODUCT__/__FEATURE__/[InterfaceName].java`
- Define the REST endpoint mappings using Spring WebFlux annotations
- **IMPORTANT**: Place ALL `*Mapping` annotations (e.g., `@GetMapping`, `@PostMapping`) and `@RequestMapping` in the interface, NOT in the controller implementation

#### Step 4: Create REST Controller (if needed)
- If PRODUCT/FEATURE folders don't exist in `*-rest`, create them and the `controller/` subfolder
- Create controller file named `[InterfaceName]Controller.java` that implements the interface from Step 3
- Place in `*-rest/src/main/java/com/[groupId]/__PRODUCT__/__FEATURE__/controller/`
- **DO NOT** create service or repository classes - this is the developer's responsibility

### Automation Scripts
Use the provided bash scripts to automate this process:
- `create-endpoint.sh` - Main script for creating endpoints
- `check-structure.sh` - Utility to check existing project structure

### Important Notes
- Always follow the existing package structure: `com.[groupId].__PRODUCT__.__FEATURE__`
- Interface names should end with appropriate suffixes (e.g., `Api`, `Controller`)  
- Controller implementations must end with `Controller` and implement the API interface
- Only create the API interface and REST controller - do not create service or repository layers
- Use reactive types (Mono/Flux) for Spring WebFlux compatibility
- **CRITICAL**: Place all `*Mapping` annotations (e.g., `@GetMapping`, `@PostMapping`) and `@RequestMapping` in the interface (API module), NOT in the controller implementation
- Controller implementations should only have `@RestController` annotation and implement the interface methods

### Example Structure After Creation
```
*-api/src/main/java/com/[groupId]/user/registration/UserRegistrationApi.java
*-rest/src/main/java/com/[groupId]/user/registration/controller/UserRegistrationController.java
```

The controller will implement the interface and provide the actual endpoint implementation.
# AI-TEMPLATE-java-reactive-multi-module

This is a **Java 21** reactive multi-module project template using Spring WebFlux, Lombok, and Netty (instead of Tomcat) for non-blocking, reactive web applications.

This project is designed for use by AI agents such as Claude Code, Copilot, Cursor, and others. Please read this README to understand the multi-module pattern and how to use or extend this template.

## ⚠️ IMPORTANT INSTRUCTIONS FOR AI/LLM AGENTS ⚠️

**BEFORE proceeding with ANY work on this project, you MUST ask the user these questions:**

1. **What is the project name?** (This will replace all instances of `AI-TEMPLATE` throughout the codebase)
2. **What is the group ID?** (This will replace `com.example` in all package structures)

**CRITICAL FOLDER CREATION RULE:**
- Do **NOT** create any `__PRODUCT__`, `__FEATURE__`, `PRODUCT`, `FEATURE`, `SUBFEATURE` folders or their children folders until explicitly asked to do so by the user
- When asked to create these folders, you MUST follow the exact format specified in the Module Structure section below
- Always ask the user to specify the actual names for `__PRODUCT__`, `__FEATURE__`, and `__SUBFEATURE__` before creating any folders

**These questions are mandatory and must be answered before any code generation or project modification.**

## Module Structure

### `*-parent`
- Controls dependency versions for all other modules using Maven's `dependencyManagement` tag (NOT `dependencies` tag).
- **Packaging:** `pom`
- Does **not** define modules in its own dependency management.
- Uses `spring-boot-starter-parent` as its parent.
- **MUST use Spring Boot version 3.5.4**
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
13. **Parent must use Spring 3.5.4**: Parent module must specify exactly Spring Boot version 3.5.4
14. **Exact dependencies**: Each module must use the exact dependencies defined in this project's parent `dependencyManagement` with exact versions AND match the corresponding module type in this template (e.g., new `*-rest` modules must use same dependencies as this template's `*-rest` module)
15. **Template compliance**: Parent must only use dependencies defined in this template - no additional dependencies allowed
16. **No circular dependencies**: Model → API → REST (never reverse)
17. **Model isolation**: Model module should not depend on API or REST modules
18. **API purity**: API module contains only interface definitions, no implementations

### Naming Convention Rules
19. **Module naming**: Use `[project-name]-[module-type]` pattern
20. **Interface naming**: End API interfaces with appropriate suffixes (`Controller`, `Service`, `Repository`)
21. **Class naming**: Implementation classes should clearly indicate their purpose and layer

### Architecture Rules
22. **Separation of concerns**: Keep transport objects separate from JPA entities
23. **Reactive patterns**: Use reactive streams (Mono/Flux) in API definitions when applicable
24. **WebFlux + Netty**: This project uses Spring WebFlux with Netty (not Tomcat) for reactive, non-blocking operations
25. **Configuration centralization**: Environment-specific config in REST module only
26. **Single responsibility**: Each module has one clear purpose and boundary

### Build and Deployment Rules
27. **Root POM management**: List all modules in root `pom.xml` with proper build order
28. **SCM configuration**: Always include proper SCM section in root POM
29. **Profile support**: Use Spring profiles for environment-specific configurations

### Code Quality Rules
30. **No business logic in API**: Keep API module purely declarative
31. **Proper error handling**: Implement consistent error handling patterns across REST implementations
32. **Documentation**: Each interface and major class should have appropriate JavaDoc
33. **Testing strategy**: Unit tests in each module, integration tests in REST module

### Extension Rules
34. **Adding new features**: Create new packages following the established structure
35. **Cross-cutting concerns**: Handle in REST module configuration, not in API or model
36. **Third-party integrations**: Isolate in REST module, expose through API interfaces only

These rules ensure maintainable, scalable, and properly architected multi-module reactive Java applications that can be easily understood and extended by AI assistants.
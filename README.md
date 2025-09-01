# AI-TEMPLATE-java-reactive-multi-module

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
- Controls dependency versions for all other modules using Maven's dependency management.
- **Packaging:** `pom`
- Does **not** define modules in its own dependency management.
- Uses `spring-boot-starter-parent` as its parent.

### `*-api`
- **Packaging:** `jar`
- Contains only a `src` directory for source code and a `pom.xml`.
- May include additional files (e.g., Lombok configuration).
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

2. **API (`*-api`)**:  
   - Depends on the model module.
   - Uses the parent module as its parent.

3. **Model (`*-model`)**:  
   - Does **not** depend on other modules.
   - Uses the parent module as its parent.

4. **REST (`*-rest`)**:  
   - Depends on the model and API modules (and any other required modules).

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
12. **Parent defines versions**: All version management in parent module's `dependencyManagement`
13. **No circular dependencies**: Model → API → REST (never reverse)
14. **Model isolation**: Model module should not depend on API or REST modules
15. **API purity**: API module contains only interface definitions, no implementations

### Naming Convention Rules
16. **Module naming**: Use `[project-name]-[module-type]` pattern
17. **Interface naming**: End API interfaces with appropriate suffixes (`Controller`, `Service`, `Repository`)
18. **Class naming**: Implementation classes should clearly indicate their purpose and layer

### Architecture Rules
19. **Separation of concerns**: Keep transport objects separate from JPA entities
20. **Reactive patterns**: Use reactive streams (Mono/Flux) in API definitions when applicable
21. **Configuration centralization**: Environment-specific config in REST module only
22. **Single responsibility**: Each module has one clear purpose and boundary

### Build and Deployment Rules
23. **Root POM management**: List all modules in root `pom.xml` with proper build order
24. **SCM configuration**: Always include proper SCM section in root POM
25. **Profile support**: Use Spring profiles for environment-specific configurations

### Code Quality Rules
26. **No business logic in API**: Keep API module purely declarative
27. **Proper error handling**: Implement consistent error handling patterns across REST implementations
28. **Documentation**: Each interface and major class should have appropriate JavaDoc
29. **Testing strategy**: Unit tests in each module, integration tests in REST module

### Extension Rules
30. **Adding new features**: Create new packages following the established structure
31. **Cross-cutting concerns**: Handle in REST module configuration, not in API or model
32. **Third-party integrations**: Isolate in REST module, expose through API interfaces only

These rules ensure maintainable, scalable, and properly architected multi-module reactive Java applications that can be easily understood and extended by AI assistants.
# fhirz

A lightweight FHIR client library written in Zig, targeting the [FHIR R5](https://hl7.org/fhir/) specification.

## Features

**Models**
- ✅ Patient
- More resources coming soon

**Client Operations**
- ✅ GET (read resources)
- ✅ POST (create resources)
- PUT, DELETE, and search operations planned

## Quick Start

1. **Configure your FHIR server** in `config.json`:
   ```json
   {
     "fhir_server": "http://localhost:8080/fhir"
   }
   ```

2. **Install**:
   ```bash
   zig fetch --save "https://github.com/JoshLankford/fhirz#master"
   ```

3. **Update Build**:
  ```zig
    exe_mod.addImport("test_fhirz_lib", lib_mod);
    exe.root_module.addImport("fhirz", fhirz.module("fhirz"));
  ```

## Development Setup

For local testing, you can spin up a FHIR server using the HAPI-FHIR starter:

```bash
docker pull hapiproject/hapi:latest
docker run -p 8080:8080 hapiproject/hapi:latest
```

The server will be available at `http://localhost:8080/fhir`.

## License

MIT

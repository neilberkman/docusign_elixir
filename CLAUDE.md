# CRITICAL RULES FOR CLAUDE

## 🚨 ABSOLUTE CI REQUIREMENTS 🚨

### **THE CI WILL NOT PASS IF THERE ARE ANY ISSUES AT ALL**

**THIS IS NON-NEGOTIABLE:**

- **ANY failing test on a branch is BY DEFINITION the result of problems on that branch**
- **ALL tests MUST pass - ZERO failures allowed**
- **NEVER declare success with ANY failing tests**
- **NEVER declare success with ANY other issues that would cause CI to fail**

### Test Failure Protocol:

1. **STOP** - Do not proceed with any other work
2. **INVESTIGATE** - Determine if the failure is due to:
   - Application code changes
   - Test code issues
   - Environment/configuration problems
3. **FIX THE ROOT CAUSE** - Do NOT just hack tests to pass
4. **VERIFY** - Run tests multiple times to ensure they pass consistently
5. **ONLY THEN** proceed with other work

### Common CI Failure Points:

- Failing tests (even 1 failure = CI failure)
- Compilation warnings with `--warnings-as-errors`
- Linting failures (credo, format check)
- Dialyzer errors
- Documentation generation failures

## Development Commands

### Testing

- `mix test` - Run all tests (MUST PASS 100%)
- `mix test --seed <number>` - Run with specific seed for reproducibility
- `mix test <file>:<line>` - Run specific test

### Code Quality

- `mix format --check-formatted` - Check formatting (CI requirement)
- `mix credo --strict` - Run static analysis (CI requirement)
- `mix dialyzer` - Run type checking (CI requirement)

### Regeneration

- `cd scripts/regen && ./regenerate_library.sh` - Regenerate API from OpenAPI spec
- Use `--download` flag to force download latest spec
- Use `--generate` flag to force regeneration

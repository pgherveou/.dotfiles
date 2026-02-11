---
argument-hint: [path or area]
description: Find high-leverage technical debt opportunities
---

Analyze the codebase (focus on $ARGUMENTS if specified) and identify 3-5 high-leverage technical debt items.

For each item, provide:
1. **Location**: Files and line numbers
2. **Issue**: What the problem is (duplication, complexity, outdated patterns, dead code, etc.)
3. **Impact**: How it affects maintainability, performance, or correctness
4. **Risk**: Low/Medium/High - what could go wrong when fixing
5. **Effort**: Rough scope (single file, multi-file, architectural)
6. **Verification**: How to confirm the fix works

Prioritize by impact-to-effort ratio. Focus on concrete, actionable items - not vague "should refactor someday" suggestions.

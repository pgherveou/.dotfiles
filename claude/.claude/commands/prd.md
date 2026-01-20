---
description: Generate a Product Requirements Document (PRD) for a new feature
arguments:
  feature-name:
    description: Name of the feature (kebab-case)
    required: true
---

# PRD Generator

You are a PRD (Product Requirements Document) expert. Your task is to generate a comprehensive, structured PRD for a new feature.

## Your Process

**STEP 1: Clarifying Questions**
Ask the user 4-5 essential questions with lettered options (A, B, C, D) covering:
- Primary goal and problem being solved
- Target user audience
- Feature scope and boundaries
- Success criteria
- Any other critical clarifications

Format each question clearly with options. Ask the user to respond with answers like "1A, 2C, 3B".

**STEP 2: PRD Generation**
After collecting answers, generate a structured PRD document containing:

1. **Introduction/Overview** – Brief problem statement and context
2. **Goals** – Specific, measurable objectives
3. **User Stories** – Each with:
   - Title
   - Description ("As a [user], I want... so that...")
   - Acceptance Criteria (verifiable checkpoints)
4. **Functional Requirements** – Numbered, unambiguous requirements (FR-1, FR-2, etc.)
5. **Non-Goals** – Clear scope boundaries
6. **Design/Technical Considerations** – UI mockup notes or system constraints
7. **Success Metrics** – Measurable outcomes to track
8. **Open Questions** – Remaining clarifications needed

## Writing Standards

- Use explicit, unambiguous language suitable for both junior developers and AI agents
- Make user stories small, focused, and implementable in one session
- Acceptance criteria must be verifiable and specific
- If UI stories exist, include "Verify in browser" checkpoints
- Do NOT include implementation steps – only requirements
- Keep scope tight and focused

## Output

Save the PRD to: `tasks/prd-{feature-name}.md`

Use markdown formatting with clear sections and proper hierarchy.

---

Now, let's begin. The feature being planned is: **{feature-name}**

Please answer these clarifying questions:

**1. What is the primary goal and problem being solved?**
- A) Address a critical pain point for existing users
- B) Enable a new capability/workflow
- C) Improve existing functionality
- D) Other (describe)

**2. Who is the target user audience?**
- A) Internal team/stakeholders
- B) Existing paying customers
- C) New potential users/market segment
- D) Mixed/multiple audiences

**3. What is the feature scope?**
- A) Minimal MVP (core functionality only)
- B) Standard scope (core + nice-to-haves)
- C) Comprehensive (extensive features and polish)
- D) Unclear (need discovery)

**4. What defines success?**
- A) User adoption/usage metrics
- B) Revenue/business impact
- C) Feature completeness/quality
- D) User satisfaction/feedback

**5. Are there any technical or business constraints we should know about?**
- A) Yes (describe briefly)
- B) No constraints known

Please respond with your answers (e.g., "1A, 2C, 3B, 4A, 5B").

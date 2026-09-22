# GitHub Copilot Toolbox — MCP & Skills awareness

_Generated: 2026-09-03T18:25:16.073Z_

## How to use this report

- **Saved copy:** This file is **`.github/copilot-toolbox-mcp-skills-awareness.md`** — refreshed whenever the toolbox runs an MCP & Skills scan (including on workspace open when auto-scan is enabled). It is meant for **Copilot workspace context** together with `.github/copilot-instructions.md` (which gets a shorter replaceable summary when auto-merge is on).
- **MCP:** Lists **configured** servers from `mcp.json`. **Live tool use** still requires **Copilot Chat → Agent** with those servers **trusted/started** in the MCP tools UI.
- **Skills:** **On-disk** folders with `SKILL.md`. Copilot does not auto-load them; attach `SKILL.md` or paths in chat when useful.
- **Task routing:** When the user’s request matches a server’s purpose (e.g. Confluence → Confluence/Atlassian MCP), prefer that **server id** from the tables below.

---

## MCP — workspace

Workspace `mcp.json` _(folder: getting_strange)_

- **c:\getting_strange\.vscode\mcp.json** — _File missing_

_No active workspace servers in mcp.json._

## MCP — user profile

- **C:\Users\admin\AppData\Roaming\Code\User\mcp.json** — _File exists — servers defined_

| Server id | Kind | Detail |
|-----------|------|--------|
| my-mcp-server-e7ac5ab2 | http | https://github.com/obra/superpowers-marketplace |
| godot-mcp | stdio | npx -y @coding-solo/godot-mcp |
| everything | stdio | npx @modelcontextprotocol/server-everything |
| microsoft/markitdown | stdio | uvx markitdown-mcp@0.0.1a4 |
| io.github.upstash/context7 | stdio | npx @upstash/context7-mcp@1.0.31 |
| io.github.ChromeDevTools/chrome-devtools-mcp | stdio | npx --registry https://registry.npmjs.org chrome-devtools-mcp@1.1.0 |
| microsoft/playwright-mcp | stdio | npx @playwright/mcp@latest |
| io.github.github/github-mcp-server | http | https://api.githubcopilot.com/mcp/ |
| io.github.wonderwhy-er/desktop-commander | stdio | npx --registry https://registry.npmjs.org @wonderwhy-er/desktop-commander@0.2.41 |
| com.microsoft/nuget | stdio | dnx NuGet.Mcp.Server@1.4.3 --yes --source https://api.nuget.org/v3/index.json |
| com.figma.mcp/mcp | http | https://mcp.figma.com/mcp |
| doist/todoist-ai | http | https://ai.todoist.net/mcp |
| io.github.microsoft/awesome-copilot | stdio | docker run -i --rm ghcr.io/microsoft/mcp-dotnet-samples/awesome-copilot:1.0.2026052503 |
| huggingface/hf-mcp-server | http | https://huggingface.co/mcp?login |
| microsoftdocs/mcp | http | https://learn.microsoft.com/api/mcp |
| io.github.vercel/next-devtools-mcp | stdio | npx next-devtools-mcp@0.3.6 |
| io.github.f/prompts.chat-mcp | stdio | npx @fkadev/prompts.chat-mcp@1.0.9 |
| io.github.contextstreamio/mcp-server | stdio | npx @contextstream/mcp-server@0.3.63 |
| com.vercel/vercel-mcp | http | https://mcp.vercel.com |
| MCP_DOCKER | stdio | docker mcp gateway run --profile ai_coding |
| @n24q02m/better-godot-mcp | stdio | npx @n24q02m/better-godot-mcp@1.18.7 |
| godotlens-mcp | stdio | npx godotlens-mcp@1.0.5 |
| datacloud_bigquery_remote | http | https://bigquery.googleapis.com/mcp |
| datacloud_knowledge_catalog_remote | http | https://dataplex.googleapis.com/mcp |
| datacloud_spanner_remote | http | https://spanner.googleapis.com/mcp |
| datacloud_alloydb_remote | http | https://alloydb.googleapis.com/mcp |
| datacloud_dataproc_remote | http | https://dataproc-${REGION}.googleapis.com/mcp |
| datacloud_cloud-sql_remote | http | https://sqladmin.googleapis.com/mcp |

## Skills (local `SKILL.md` folders)

### Project-scoped

- **2d-essentials** — `c:\getting_strange\.agents\skills\2d-essentials`
  - Use when working with 2D-specific systems — TileMaps, parallax scrolling, 2D lights and shadows, canvas layers, particles 2D, custom drawing, and 2D meshes in Godot 4.3+

- **acsets-relational-thinking** — `c:\getting_strange\.agents\skills\acsets-relational-thinking`
  - database, category-theory, rewriting

- **adapt** — `c:\getting_strange\.agents\skills\adapt`
  - Adapt designs to work across different screen sizes, devices, contexts, or platforms. Implements breakpoints, fluid layouts, and touch targets. Use when the user mentions responsive design, mobile layouts, breakpoints, v

- **add-3d-assets** — `c:\getting_strange\.agents\skills\add-3d-assets`
  - Replace primitive 3D shapes with real GLB models — animated characters, world props, buildings, and scenery for Three.js games. Use when the user says \"add 3D models\", \"replace the boxes with real models\", \"add GLB 

- **add-assets** — `c:\getting_strange\.agents\skills\add-assets`
  - Replace geometric shapes with pixel art sprites — recognizable characters, enemies, and items with optional animation. Use when the user says \"add sprites\", \"replace the shapes with real art\", \"add pixel art\", \"ma

- **add-audio** — `c:\getting_strange\.agents\skills\add-audio`
  - Add music and sound effects to a game using the Web Audio API — background music, gameplay themes, and SFX. Zero dependencies. Use when the user says \"add music\", \"add sound effects\", \"add audio\", \"make it sound g

- **add-feature** — `c:\getting_strange\.agents\skills\add-feature`
  - Add a new gameplay feature to an existing browser game following its architecture patterns. Use when the user says \"add a feature\", \"add double-jump\", \"add a power-up\", \"add a leaderboard\", or describes a specifi

- **add-multiplayer** — `c:\getting_strange\.agents\skills\add-multiplayer`
  - Add real-time or turn-based multiplayer to an existing browser game using PartyKit (Cloudflare Durable Objects). Scaffolds a room-based server, a NetworkManager client, EventBus events, GameState fields, Constants, and e

- **agent-agent** — `c:\getting_strange\.agents\skills\agent-agent`
  - Agent skill for agent - invoke with $agent-agent

- **agent-analyze-code-quality** — `c:\getting_strange\.agents\skills\agent-analyze-code-quality`
  - Agent skill for analyze-code-quality - invoke with $agent-analyze-code-quality

- **agent-app-store** — `c:\getting_strange\.agents\skills\agent-app-store`
  - Agent skill for app-store - invoke with $agent-app-store

- **agent-arch-system-design** — `c:\getting_strange\.agents\skills\agent-arch-system-design`
  - Agent skill for arch-system-design - invoke with $agent-arch-system-design

- **agent-architecture** — `c:\getting_strange\.agents\skills\agent-architecture`
  - Agent skill for architecture - invoke with $agent-architecture

- **agent-benchmark-suite** — `c:\getting_strange\.agents\skills\agent-benchmark-suite`
  - Agent skill for benchmark-suite - invoke with $agent-benchmark-suite

- **agent-code-goal-planner** — `c:\getting_strange\.agents\skills\agent-code-goal-planner`
  - Agent skill for code-goal-planner - invoke with $agent-code-goal-planner

- **agent-code-review-swarm** — `c:\getting_strange\.agents\skills\agent-code-review-swarm`
  - Agent skill for code-review-swarm - invoke with $agent-code-review-swarm

- **agent-coder** — `c:\getting_strange\.agents\skills\agent-coder`
  - Agent skill for coder - invoke with $agent-coder

- **agent-coordination** — `c:\getting_strange\.agents\skills\agent-coordination`
  - >

- **agent-coordinator-swarm-init** — `c:\getting_strange\.agents\skills\agent-coordinator-swarm-init`
  - Agent skill for coordinator-swarm-init - invoke with $agent-coordinator-swarm-init

- **agent-dev-backend-api** — `c:\getting_strange\.agents\skills\agent-dev-backend-api`
  - Agent skill for dev-backend-api - invoke with $agent-dev-backend-api

- **agent-goal-planner** — `c:\getting_strange\.agents\skills\agent-goal-planner`
  - Agent skill for goal-planner - invoke with $agent-goal-planner

- **agent-memory-coordinator** — `c:\getting_strange\.agents\skills\agent-memory-coordinator`
  - Agent skill for memory-coordinator - invoke with $agent-memory-coordinator

- **agent-orchestrator-task** — `c:\getting_strange\.agents\skills\agent-orchestrator-task`
  - Agent skill for orchestrator-task - invoke with $agent-orchestrator-task

- **agent-payments** — `c:\getting_strange\.agents\skills\agent-payments`
  - Agent skill for payments - invoke with $agent-payments

- **agent-performance-analyzer** — `c:\getting_strange\.agents\skills\agent-performance-analyzer`
  - Agent skill for performance-analyzer - invoke with $agent-performance-analyzer

- **agent-performance-benchmarker** — `c:\getting_strange\.agents\skills\agent-performance-benchmarker`
  - Agent skill for performance-benchmarker - invoke with $agent-performance-benchmarker

- **agent-performance-monitor** — `c:\getting_strange\.agents\skills\agent-performance-monitor`
  - Agent skill for performance-monitor - invoke with $agent-performance-monitor

- **agent-performance-optimizer** — `c:\getting_strange\.agents\skills\agent-performance-optimizer`
  - Agent skill for performance-optimizer - invoke with $agent-performance-optimizer

- **agent-planner** — `c:\getting_strange\.agents\skills\agent-planner`
  - Agent skill for planner - invoke with $agent-planner

- **agent-researcher** — `c:\getting_strange\.agents\skills\agent-researcher`
  - Agent skill for researcher - invoke with $agent-researcher

- **agent-skill-discovery** — `c:\getting_strange\.agents\skills\agent-skill-discovery`
  - This skill should be used when the user wants to see all installed plugins, agents, skills, and MCP servers, and also inspect the current repository for local agents, skills, and MCP configuration. Scans the environment 

- **agent-specification** — `c:\getting_strange\.agents\skills\agent-specification`
  - Agent skill for specification - invoke with $agent-specification

- **agent-swarm-memory-manager** — `c:\getting_strange\.agents\skills\agent-swarm-memory-manager`
  - Agent skill for swarm-memory-manager - invoke with $agent-swarm-memory-manager

- **agent-user-tools** — `c:\getting_strange\.agents\skills\agent-user-tools`
  - Agent skill for user-tools - invoke with $agent-user-tools

- **agent-v3-integration-architect** — `c:\getting_strange\.agents\skills\agent-v3-integration-architect`
  - Agent skill for v3-integration-architect - invoke with $agent-v3-integration-architect

- **agent-v3-memory-specialist** — `c:\getting_strange\.agents\skills\agent-v3-memory-specialist`
  - Agent skill for v3-memory-specialist - invoke with $agent-v3-memory-specialist

- **agent-v3-performance-engineer** — `c:\getting_strange\.agents\skills\agent-v3-performance-engineer`
  - Agent skill for v3-performance-engineer - invoke with $agent-v3-performance-engineer

- **agent-v3-queen-coordinator** — `c:\getting_strange\.agents\skills\agent-v3-queen-coordinator`
  - Agent skill for v3-queen-coordinator - invoke with $agent-v3-queen-coordinator

- **agent-v3-security-architect** — `c:\getting_strange\.agents\skills\agent-v3-security-architect`
  - Agent skill for v3-security-architect - invoke with $agent-v3-security-architect

- **ai-assistant** — `c:\getting_strange\.agents\skills\ai-assistant`
  - Build AI assistant application with NLU, dialog management, and integrations

- **ai-engineer** — `c:\getting_strange\.agents\skills\ai-engineer`
  - Build production-ready LLM applications, advanced RAG systems, and intelligent agents. Implements vector search, multimodal AI, agent orchestration, and enterprise AI integrations. Use PROACTIVELY for LLM features, chatb

- **ai-review** — `c:\getting_strange\.agents\skills\ai-review`
  - You are an expert AI-powered code review specialist combining automated static analysis, intelligent pattern recognition, and modern DevOps practices. Leverage AI tools (GitHub Copilot, Qodo, GPT-5, Codex 4.5 Sonnet) wit

- **algorithmic-art** — `c:\getting_strange\.agents\skills\algorithmic-art`
  - Creating algorithmic art using p5.js with seeded randomness and interactive parameter exploration. Use when users request creating art using code, generative art, algorithmic art, flow fields, or particle systems.

- **android-ci-cd-release-playstore** — `c:\getting_strange\.agents\skills\android-ci-cd-release-playstore`
  - Automate Android CI, versioning, signing boundaries, release channels, and Play-ready delivery workflows.

- **android-clean-architecture** — `c:\getting_strange\.agents\skills\android-clean-architecture`
  - Clean Architecture patterns for Android and Kotlin Multiplatform projects — module structure, dependency rules, UseCases, Repositories, and data layer patterns.

- **android-cli** — `c:\getting_strange\.agents\skills\android-cli`
  - Provides instructions for installing and using the `android` CLI. The `android` command-line tool is a critical tool for Android development and helps you create new Android projects, run Android apps on devices, manage 

- **android-kotlin** — `c:\getting_strange\.agents\skills\android-kotlin`
  - Android Kotlin development with Coroutines, Jetpack Compose, Hilt, and MockK testing

- **android-native-dev** — `c:\getting_strange\.agents\skills\android-native-dev`
  - Android native application development and UI design guide. Covers Material Design 3, Kotlin/Compose development, project configuration, accessibility, and build troubleshooting. Read this before Android native applicati

- **android-playstore-scan** — `c:\getting_strange\.agents\skills\android-playstore-scan`
  - Scan Android project and generate Play Console setup checklist (analysis only, no file modifications)

- **android-playstore-setup** — `c:\getting_strange\.agents\skills\android-playstore-setup`
  - Complete Play Store setup - orchestrates scanning, privacy policy, version management, Fastlane, and workflows (Internal track only)

- **animate** — `c:\getting_strange\.agents\skills\animate`
  - Review a feature and enhance it with purposeful animations, micro-interactions, and motion effects that improve usability and delight. Use when the user mentions adding animation, transitions, micro-interactions, motion 

- **animated-component-libraries** — `c:\getting_strange\.agents\skills\animated-component-libraries`
  - Pre-built animated React component collections combining Magic UI (150+ TypeScript/Tailwind/Motion components) and React Bits (90+ minimal-dependency animated components). Use this skill when building landing pages, mark

- **animation-libraries** — `c:\getting_strange\.agents\skills\animation-libraries`
  - Skill for animation-libraries tasks.

- **backend-architect** — `c:\getting_strange\.agents\skills\backend-architect`
  - Expert backend architect specializing in scalable API design, microservices architecture, and distributed systems. Masters REST/GraphQL/gRPC APIs, event-driven architectures, service mesh patterns, and modern backend fra

- **banana** — `c:\getting_strange\.agents\skills\banana`
  - AI image generation Creative Director powered by Google Gemini Nano Banana models. Use this skill for ANY request involving image creation, editing, visual asset production, or creative direction. Triggers on: generate a

- **browser** — `c:\getting_strange\.agents\skills\browser`
  - Web browser automation with AI-optimized snapshots for Codex-flow agents

- **calendar-acset** — `c:\getting_strange\.agents\skills\calendar-acset`
  - Google Calendar management via CalendarACSet. Transforms scheduling operations into GF(3)-typed Interactions, routes to triadic queues, detects saturation for balanced-calendar-as-condensed-state.

- **camera-systems** — `c:\getting_strange\.agents\skills\camera-systems`
  - >

- **capability-evolver** — `c:\getting_strange\.agents\skills\capability-evolver`
  - A self-evolution engine for AI agents. Analyzes runtime history to identify improvements and applies protocol-constrained evolution. Communicates with EvoMap Hub via local Proxy mailbox.

- **chain-of-thought** — `c:\getting_strange\.agents\skills\chain-of-thought`
  - Skill for chain-of-thought tasks.

- **code-explain** — `c:\getting_strange\.agents\skills\code-explain`
  - You are a code education expert specializing in explaining complex code through clear narratives, visual diagrams, and step-by-step breakdowns. Transform difficult concepts into understandable explanations for developers

- **code-reviewer** — `c:\getting_strange\.agents\skills\code-reviewer`
  - Elite code review expert specializing in modern AI-powered code analysis, security vulnerabilities, performance optimization, and production reliability. Masters static analysis tools, security scanning, and configuratio

- **color-envelope-preserving** — `c:\getting_strange\.agents\skills\color-envelope-preserving`
  - GF(3) color envelope preservation across navigator compositions

- **color-systems** — `c:\getting_strange\.agents\skills\color-systems`
  - Skill for color-systems tasks.

- **concept-design** — `c:\getting_strange\.agents\skills\concept-design`
  - ゲームのコンセプトデザインを言語化するためのスキル。漠然としたアイデアを設計可能な形に変換する。使用タイミング：(1)「ゲームのコンセプトを考えたい」(2)「新しいゲームを作りたい」(3)「アイデアを整理したい」と言われた時。判断・行動・体験を中心に据えた設計言語を生成する。

- **config-validate** — `c:\getting_strange\.agents\skills\config-validate`
  - You are a configuration management expert specializing in validating, testing, and ensuring the correctness of application configurations. Create comprehensive validation schemas, implement configuration testing strategi

- **content-marketer** — `c:\getting_strange\.agents\skills\content-marketer`
  - Elite content marketing strategist specializing in AI-powered content creation, omnichannel distribution, SEO optimization, and data-driven performance marketing. Masters modern content tools, social media automation, an

- **context-engineering** — `c:\getting_strange\.agents\skills\context-engineering`
  - Optimizes agent context setup. Use when starting a new session, when agent output quality degrades, when switching between tasks, or when you need to configure rules files and context for a project.

- **context-manager** — `c:\getting_strange\.agents\skills\context-manager`
  - Elite AI context engineering specialist mastering dynamic context management, vector databases, knowledge graphs, and intelligent memory systems. Orchestrates context across multi-agent workflows, enterprise AI systems, 

- **context-restore** — `c:\getting_strange\.agents\skills\context-restore`
  - Expert Context Restoration Specialist focused on intelligent, semantic-aware context retrieval and reconstruction across complex multi-agent AI workflows. Specializes in preserving and reconstructing 

- **context-save** — `c:\getting_strange\.agents\skills\context-save`
  - An elite context engineering specialist focused on comprehensive, semantic, and dynamically adaptable context preservation across AI workflows. This tool orchestrates advanced context capture, seriali

- **cost-optimize** — `c:\getting_strange\.agents\skills\cost-optimize`
  - You are a cloud cost optimization expert specializing in reducing infrastructure expenses while maintaining performance and reliability. Analyze cloud spending, identify savings opportunities, and implement cost-effectiv

- **create-game-assets** — `c:\getting_strange\.agents\skills\create-game-assets`
  - Plan, generate, source, normalize, and validate cohesive visual game assets. Use for art direction, style bibles, sprites, tilesets, backgrounds, UI art, icons, textures, concept art, or 3D asset briefs.

- **creating-godot-procedural-audio** — `c:\getting_strange\.agents\skills\creating-godot-procedural-audio`
  - Designs and implements procedural audio for Godot games. Use when creating runtime SFX with Godot built-in audio APIs, mapping game events to timbre, or avoiding external audio assets.

- **critique** — `c:\getting_strange\.agents\skills\critique`
  - Evaluate design from a UX perspective, assessing visual hierarchy, information architecture, emotional resonance, cognitive load, and overall quality with quantitative scoring, persona-based testing, automated anti-patte

- **critiquing-own-response** — `c:\getting_strange\.agents\skills\critiquing-own-response`
  - Performs structured, ruthless critical self-review of the agent's own immediately preceding response. Use ONLY when the user explicitly requests critical-thinking, self-critique, criticalthink, or asks the agent to chall

- **css-styling-approaches** — `c:\getting_strange\.agents\skills\css-styling-approaches`
  - Skill for css-styling-approaches tasks.

- **data-driven-feature** — `c:\getting_strange\.agents\skills\data-driven-feature`
  - Build features guided by data insights, A/B testing, and continuous measurement using specialized agents for analysis, implementation, and experimentation.

- **deep-research** — `c:\getting_strange\.agents\skills\deep-research`
  - Orchestrate multi-phase deep research with web search, memory retrieval, pattern matching, and synthesis into structured findings

- **design-game** — `c:\getting_strange\.agents\skills\design-game`
  - Audit and improve the visual design, polish, and player experience of an existing game. Use when the user says \"make my game look better\", \"improve the design\", \"add polish\", \"add juice\", \"add particles\", \"fix

- **design-review** — `c:\getting_strange\.agents\skills\design-review`
  - Review existing UI for issues and improvements

- **design-system-architect** — `c:\getting_strange\.agents\skills\design-system-architect`
  - Expert design system architect specializing in design tokens, component libraries, theming infrastructure, and scalable design operations. Masters token architecture, multi-brand systems, and design-development collabora

- **design-system-setup** — `c:\getting_strange\.agents\skills\design-system-setup`
  - Initialize a design system with tokens

- **designing-mini-games** — `c:\getting_strange\.agents\skills\designing-mini-games`
  - Designs compact, playable game rules and controls. Use when defining a new mini-game concept, converting creative constraints into mechanics, checking state-variable necessity, or preventing idle/mashing from becoming op

- **designing-one-button-games** — `c:\getting_strange\.agents\skills\designing-one-button-games`
  - Designs original one-button mini-games using tap, hold, and release controls, with emphasis on novelty, risk/reward, and a short difficulty curve. Use when planning mechanics, scoring, game-over conditions, and difficult

- **deterministic-color-generation** — `c:\getting_strange\.agents\skills\deterministic-color-generation`
  - Works offline, no external data needed

- **dev-app-assets** — `c:\getting_strange\.agents\skills\dev-app-assets`
  - Generate icons, empty states, onboarding for apps.

- **dev-avatar-service** — `c:\getting_strange\.agents\skills\dev-avatar-service`
  - Deterministic default-avatar generator per user.

- **dev-screenshot-beautifier** — `c:\getting_strange\.agents\skills\dev-screenshot-beautifier`
  - Polish raw screenshots into LP-ready heroes.

- **developing-with-crisp-game-lib** — `c:\getting_strange\.agents\skills\developing-with-crisp-game-lib`
  - Creates or repairs browser mini-games specifically using crisp-game-lib. Use only when the user explicitly asks for crisp-game-lib or the existing project already uses it; skip for Godot, Unity, Phaser, canvas-only, or u

- **dialogue-systems** — `c:\getting_strange\.agents\skills\dialogue-systems`
  - >

- **directing-game-visuals** — `c:\getting_strange\.agents\skills\directing-game-visuals`
  - Directs readable, coherent game visuals. Use when defining visual hierarchy, palette roles, screen composition, event feedback, or reducing generic AI-looking game art without relying on HUD text.

- **documentation-and-adrs** — `c:\getting_strange\.agents\skills\documentation-and-adrs`
  - Records decisions and documentation. Use when making architectural decisions, changing public APIs, shipping features, or when you need to record context that future engineers and agents will need to understand the codeb

- **documentation-writer** — `c:\getting_strange\.agents\skills\documentation-writer`
  - Diátaxis Documentation Expert. An expert technical writer specializing in creating high-quality software documentation, guided by the principles and structure of the Diátaxis technical documentation authoring framework.

- **emotional-narrative** — `c:\getting_strange\.agents\skills\emotional-narrative`
  - Use when animation needs to convey feeling, tell a story, or connect emotionally—character moments, dramatic beats, or any motion that should make the audience care.

- **error-analysis** — `c:\getting_strange\.agents\skills\error-analysis`
  - You are an expert error analysis specialist with deep expertise in debugging distributed systems, analyzing production incidents, and implementing comprehensive observability solutions.

- **error-detective** — `c:\getting_strange\.agents\skills\error-detective`
  - Search logs and codebases for error patterns, stack traces, and anomalies. Correlates errors across systems and identifies root causes. Use PROACTIVELY when debugging issues, analyzing logs, or investigating production e

- **error-trace** — `c:\getting_strange\.agents\skills\error-trace`
  - You are an error tracking and observability expert specializing in implementing comprehensive error monitoring solutions. Set up error tracking systems, configure alerts, implement structured logging, and ensure teams ca

- **evaluating-gameplay-balance** — `c:\getting_strange\.agents\skills\evaluating-gameplay-balance`
  - Evaluates and improves gameplay balance from telemetry in any engine. Use when comparing monotonous vs exploratory play, diagnosing death/spawn/scoring/input issues, or proposing structural balance fixes instead of numer

- **event-sourcing-architect** — `c:\getting_strange\.agents\skills\event-sourcing-architect`
  - Expert in event sourcing, CQRS, and event-driven architecture patterns. Masters event store design, projection building, saga orchestration, and eventual consistency patterns. Use PROACTIVELY for event-sourced systems, a

- **experience-design** — `c:\getting_strange\.agents\skills\experience-design`
  - Engagement loop design, pacing frameworks, the Experience Triangle (mechanics + dynamics + aesthetics), emotion layering across a session, and evaluating whether choices feel meaningful. Use when designing the core loop,

- **extracting-agent-skills** — `c:\getting_strange\.agents\skills\extracting-agent-skills`
  - Distills reusable agent skills (procedures, validation loops, debugging methods, tool-use patterns, decision rules) from completed, abandoned, paused, or failed projects. Use when closing/archiving a project, reducing si

- **eyes** — `c:\getting_strange\.agents\skills\eyes`
  - WHEN users express dissatisfaction with visual appearance or behavior; use Playwright MCP to capture screenshots and collaborate on UI fixes with a structured feedback loop.

- **fantasy-world-building** — `c:\getting_strange\.agents\skills\fantasy-world-building`
  - Use when user mentions fantasy, magic system, or world-building for fantastical settings - provides fantasy genre conventions, magic system design patterns, and world-building frameworks

- **feature-development** — `c:\getting_strange\.agents\skills\feature-development`
  - Orchestrate end-to-end feature development from requirements to production deployment:

- **fetch-tweet** — `c:\getting_strange\.agents\skills\fetch-tweet`
  - Fetch tweet content directly from fxtwitter API. Use when given a tweet/X URL to extract the tweet text, author, media, and engagement stats without loading x.com.

- **fiction-writer** — `c:\getting_strange\.agents\skills\fiction-writer`
  - Écrit un court segment fictionnel immersif pour l'Acte IV d'un épisode NEW TEMPS X. Utilise ce Skill quand tu dois créer une scène fictionnelle qui illustre les implications d'un sujet scientifique, faire ressentir plutô

- **find-skills** — `c:\getting_strange\.agents\skills\find-skills`
  - Helps users discover, search, and install skills from the skills.sh registry using the npx skills CLI. Use this skill when users ask to find skills, browse the skill registry, install a skill, or search for skills by nam

- **forgotten-elements-reminder** — `c:\getting_strange\.agents\skills\forgotten-elements-reminder`
  - Automatically reminds when important story elements (characters, plot lines, foreshadowing) haven't appeared for 10+ chapters - prevents 'disappeared character syndrome' and dropped plot threads in long-form fiction

- **fresh-eyes** — `c:\getting_strange\.agents\skills\fresh-eyes`
  - Re-reads code you just wrote with fresh perspective to catch bugs, errors, and issues. Use after completing a feature, fixing a bug, or any code changes. Triggers on \"review my code\", \"fresh eyes\", \"check for bugs\"

- **frontend-design** — `c:\getting_strange\.agents\skills\frontend-design`
  - Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing

- **frontend-developer** — `c:\getting_strange\.agents\skills\frontend-developer`
  - Build React components, implement responsive layouts, and handle client-side state management. Masters React 19, Next.js 15, and modern frontend architecture. Optimizes performance and ensures accessibility. Use PROACTIV

- **frontend-security-coder** — `c:\getting_strange\.agents\skills\frontend-security-coder`
  - Expert in secure frontend coding practices specializing in XSS prevention, output sanitization, and client-side security patterns. Use PROACTIVELY for frontend security implementations or client-side security code review

- **frontend-ui-engineering** — `c:\getting_strange\.agents\skills\frontend-ui-engineering`
  - Builds production-quality UIs. Use when building or modifying user-facing interfaces. Use when creating components, implementing layouts, managing state, or when the output needs to look and feel production-quality rathe

- **full-review** — `c:\getting_strange\.agents\skills\full-review`
  - Orchestrate comprehensive multi-dimensional code review using specialized review agents

- **game-3d-assets** — `c:\getting_strange\.agents\skills\game-3d-assets`
  - 3D asset engineer that finds, downloads, and integrates GLB/GLTF models into Three.js browser games. Use when a 3D game needs real models instead of primitive BoxGeometry/SphereGeometry shapes.

- **game-ai** — `c:\getting_strange\.agents\skills\game-ai`
  - >

- **game-architecture** — `c:\getting_strange\.agents\skills\game-architecture`
  - Game architecture patterns and best practices for browser games. Use when designing game systems, planning architecture, structuring a game project, or making architectural decisions about game code.

- **game-artist** — `c:\getting_strange\.agents\skills\game-artist`
  - Visual style, rendering techniques, and animation for web games. Invoked by game-orchestra when code works but needs visual polish. Covers CSS/canvas art, color palettes, animation, responsive design, and game juice.

- **game-asset-generation** — `c:\getting_strange\.agents\skills\game-asset-generation`
  - Generate game art assets using each::sense AI. Create 2D sprites, character sprite sheets, seamless textures, UI elements, icons, tilesets, loading screens, logos, and concept art for games.

- **game-assets** — `c:\getting_strange\.agents\skills\game-assets`
  - Game asset engineer that creates pixel art sprites, animated characters, and visual entities for browser games. Use when a game needs better character art, enemy sprites, item visuals, or any upgrade from basic geometric

- **game-audio** — `c:\getting_strange\.agents\skills\game-audio`
  - Game audio engineer using Web Audio API for procedural music and sound effects in browser games. Zero dependencies. Use when adding music or SFX to a game.

- **game-balancing** — `c:\getting_strange\.agents\skills\game-balancing`
  - >

- **game-deploy** — `c:\getting_strange\.agents\skills\game-deploy`
  - Deploy browser games to here.now (default), GitHub Pages, or other hosting. Use when deploying a game, setting up hosting, or publishing a game build. Do NOT use for local development servers (use npm run dev).

- **game-design** — `c:\getting_strange\.agents\skills\game-design`
  - 遊戲設計理論、機制設計與玩家體驗

- **game-design-core** — `c:\getting_strange\.agents\skills\game-design-core`
  - The foundational theory of interactive experience design - loops, motivation, feel, and the art of meaningful playUse when \"game design, core loop, game feel, player motivation, game mechanics, meaningful choice, progre

- **game-design-theory** — `c:\getting_strange\.agents\skills\game-design-theory`
  - |

- **game-designer** — `c:\getting_strange\.agents\skills\game-designer`
  - Game UI/UX designer that analyzes and improves the visual polish, atmosphere, and player experience of browser games. Use when a game needs visual improvements, better backgrounds, particles, animations, screen transitio

- **game-developer** — `c:\getting_strange\.agents\skills\game-developer`
  - Use when building game systems, implementing Unity/Unreal Engine features, or optimizing game performance. Invoke to implement ECS architecture, configure physics systems and colliders, set up multiplayer networking with

- **game-development** — `c:\getting_strange\.agents\skills\game-development`
  - Game development with Unity, Unreal Engine, and Godot. Use when building games, implementing game mechanics, physics, AI, or working with game engines.

- **game-engine** — `c:\getting_strange\.agents\skills\game-engine`
  - Expert skill for building web-based game engines and games using HTML5, Canvas, WebGL, and JavaScript. Use when asked to create games, build game engines, implement game physics, handle collision detection, set up game l

- **game-feel** — `c:\getting_strange\.agents\skills\game-feel`
  - >

- **game-orchestra** — `c:\getting_strange\.agents\skills\game-orchestra`
  - Main orchestrator for web game development. Use when building, continuing, or improving a web game. Triggers on: 'build a game', 'make a game', 'game development', 'continue my game', 'improve my game'. This skill is the

- **game-perf** — `c:\getting_strange\.agents\skills\game-perf`
  - Per-frame performance and GC-pressure optimization for JS/TS game code. Use when editing game loops, update functions, render passes, physics steps, particle systems, or any code that runs every frame; when diagnosing ja

- **game-playtest-personas** — `c:\getting_strange\.agents\skills\game-playtest-personas`
  - Use when a game team needs an early, low-cost hypothesis sweep across distinct player archetypes for onboarding, UX friction, difficulty, retention, monetization, accessibility leads, milestone questions, or bug leads be

- **game-qa** — `c:\getting_strange\.agents\skills\game-qa`
  - Game QA testing with Playwright — visual regression, gameplay verification, performance, and accessibility for browser games. Use when writing or running game tests, debugging test failures, or building QA infrastructure

- **game-ui-design** — `c:\getting_strange\.agents\skills\game-ui-design`
  - World-class game UI design expertise combining the clarity of Nintendo's UI philosophy, the immersive diegetic interfaces of Dead Space and Metroid Prime, and the competitive readability principles from esports titles. G

- **game-ui-ux** — `c:\getting_strange\.agents\skills\game-ui-ux`
  - >

- **generate2dmap** — `c:\getting_strange\.agents\skills\generate2dmap`
  - Generate and revise production-oriented 2D game maps with built-in image generation as the default visual asset source, choosing a visual model, runtime object model, collision model, art direction, and engine/export tar

- **generate2dsprite** — `c:\getting_strange\.agents\skills\generate2dsprite`
  - Generate and postprocess general 2D game assets and animation sheets: pixel-art sprites, clean HD map props, creatures, characters, NPCs, spells, projectiles, impacts, props, summons, and transparent GIF exports. Use whe

- **generating-dot-assets** — `c:\getting_strange\.agents\skills\generating-dot-assets`
  - Generates transparent pixel-art object assets from a subject and target pixel size using a host-provided image-generation tool, chroma-key removal, pixelization, exact canvas fitting, and PNG validation. Use for game obj

- **getting-started-guide** — `c:\getting_strange\.agents\skills\getting-started-guide`
  - Activates when users start a new novel project - guides them through the seven-step methodology (constitution → specify → clarify → plan → tasks → write → analyze) with gentle prompts and explanations

- **github-awesome-copilot-skills-ai-team-orchestration** — `c:\getting_strange\.agents\skills\github-awesome-copilot-skills-ai-team-orchestration`
  - Bootstrap and run a multi-agent AI development team. Use when: starting a new software project with AI agents, setting up parallel dev/QA teams, creating sprint plans, writing brainstorm prompts with distinct agent voice

- **github-awesome-copilot-skills-create-architectural-decision-record** — `c:\getting_strange\.agents\skills\github-awesome-copilot-skills-create-architectural-decision-record`
  - Create an Architectural Decision Record (ADR) document for AI-optimized decision documentation.

- **godot-2d-animation** — `c:\getting_strange\.agents\skills\godot-2d-animation`
  - Expert patterns for 2D animation in Godot using AnimatedSprite2D and skeletal cutout rigs. Use when implementing sprite frame animations, procedural animation (squash/stretch), cutout bone hierarchies, or frame-perfect t

- **godot-2d-movement** — `c:\getting_strange\.agents\skills\godot-2d-movement`
  - >

- **godot-2d-physics** — `c:\getting_strange\.agents\skills\godot-2d-physics`
  - Expert patterns for Godot 2D physics including collision layers/masks, Area2D triggers, raycasting, and PhysicsDirectSpaceState2D queries. Use when implementing collision detection, trigger zones, line-of-sight systems, 

- **godot-3d-essentials** — `c:\getting_strange\.agents\skills\godot-3d-essentials`
  - >

- **godot-3d-lighting** — `c:\getting_strange\.agents\skills\godot-3d-lighting`
  - Expert patterns for Godot 3D lighting including DirectionalLight3D shadow cascades, OmniLight3D attenuation, SpotLight3D projectors, VoxelGI vs SDFGI, and LightmapGI baking. Use when implementing realistic 3D lighting, s

- **godot-ability-system** — `c:\getting_strange\.agents\skills\godot-ability-system`
  - Expert patterns for RPG/action ability systems including cooldown strategies, combo systems, ability chaining, skill trees with prerequisites, upgrade paths, and resource management. Use when implementing unlockable abil

- **godot-adapt-2d-to-3d** — `c:\getting_strange\.agents\skills\godot-adapt-2d-to-3d`
  - Expert patterns for migrating 2D games to 3D including node type conversions, camera systems (third-person, first-person, orbit), physics layer migration, sprite-to-model art pipeline, and control scheme adaptations. Use

- **godot-animation** — `c:\getting_strange\.agents\skills\godot-animation`
  - >

- **godot-animation-player** — `c:\getting_strange\.agents\skills\godot-animation-player`
  - Expert patterns for AnimationPlayer including track types (Value, Method, Audio, Bezier), root motion extraction, animation callbacks, procedural animation generation, call mode optimization, and RESET tracks. Use for ti

- **godot-animation-tree-mastery** — `c:\getting_strange\.agents\skills\godot-animation-tree-mastery`
  - Expert patterns for AnimationTree including StateMachine transitions, BlendSpace2D for directional movement, BlendTree for layered animations, root motion, transition conditions, advance expressions, and state machine su

- **godot-asset-generator** — `c:\getting_strange\.agents\skills\godot-asset-generator`
  - Generate game assets using AI image generation APIs (DALL-E, Replicate, fal.ai) and prepare them for Godot. Covers the full art pipeline from concept art and style guides to final sprites, sprite sheets, and import confi

- **godot-assets** — `c:\getting_strange\.agents\skills\godot-assets`
  - |

- **godot-audio** — `c:\getting_strange\.agents\skills\godot-audio`
  - >

- **godot-auditor** — `c:\getting_strange\.agents\skills\godot-auditor`
  - Godot Expert Auditor: Aurelius. Exhaustive never-list enforcement and architectural slap-down for Godot 4.6 projects.

- **godot-autoload-architecture** — `c:\getting_strange\.agents\skills\godot-autoload-architecture`
  - Expert patterns for Godot AutoLoad (singleton) architecture including global state management, scene transitions, signal-based communication, dependency injection, autoload initialization order, and anti-patterns to avoi

- **godot-best-practices** — `c:\getting_strange\.agents\skills\godot-best-practices`
  - Guide AI agents through Godot 4.x GDScript coding best practices including scene organization, signals, resources, state machines, and performance optimization. This skill should be used when generating GDScript code, cr

- **godot-brainstorming** — `c:\getting_strange\.agents\skills\godot-brainstorming`
  - Use when designing a new Godot feature or system — guides scene tree planning, node type selection, and architectural decisions

- **godot-builder** — `c:\getting_strange\.agents\skills\godot-builder`
  - Expert-level toolkit for modular Godot 4.x CLI automation and headless build orchestration.

- **godot-camera-systems** — `c:\getting_strange\.agents\skills\godot-camera-systems`
  - Expert patterns for 2D/3D camera control including smooth following (lerp, position_smoothing), camera shake (trauma system), screen shake with frequency parameters, deadzone/drag for platformers, look-ahead prediction, 

- **godot-characterbody-2d** — `c:\getting_strange\.agents\skills\godot-characterbody-2d`
  - Expert patterns for CharacterBody2D including platformer movement (coyote time, jump buffering, variable jump height), top-down movement (8-way, tank controls), collision handling, one-way platforms, and state machines. 

- **godot-code-review** — `c:\getting_strange\.agents\skills\godot-code-review`
  - Use when reviewing GDScript or C# Godot code — checklist of best practices, common anti-patterns, and Godot-specific pitfalls

- **godot-composition** — `c:\getting_strange\.agents\skills\godot-composition`
  - Expert architectural standards for building scalable Godot GAMES (RPGs, Platformers, Shooters) using the Composition pattern (Entity-Component). Use when designing player controllers, NPCs, enemies, weapons, or complex g

- **godot-csharp** — `c:\getting_strange\.agents\skills\godot-csharp`
  - >

- **godot-debugging** — `c:\getting_strange\.agents\skills\godot-debugging`
  - Expert knowledge of Godot debugging, error interpretation, common bugs, and troubleshooting techniques. Use when helping fix Godot errors, crashes, or unexpected behavior.

- **godot-dev** — `c:\getting_strange\.agents\skills\godot-dev`
  - Expert knowledge of Godot Engine game development including scene creation, node management, GDScript programming, and project structure. Use when working with Godot projects, creating or modifying scenes, adding nodes, 

- **godot-dialogue-system** — `c:\getting_strange\.agents\skills\godot-dialogue-system`
  - Expert patterns for branching dialogue systems including dialogue graphs (Resource-based), character portraits, player choices, conditional dialogue (flags/quests), typewriter effects, localization support, and voice act

- **godot-effects** — `c:\getting_strange\.agents\skills\godot-effects`
  - |

- **godot-export** — `c:\getting_strange\.agents\skills\godot-export`
  - >

- **godot-game-loop-collection** — `c:\getting_strange\.agents\skills\godot-game-loop-collection`
  - Use when implementing collection quests, scavenger hunts, or \"find all X\" objectives.

- **godot-gdscript** — `c:\getting_strange\.agents\skills\godot-gdscript`
  - >

- **godot-gdscript-mastery** — `c:\getting_strange\.agents\skills\godot-gdscript-mastery`
  - Expert GDScript best practices including static typing (var x: int, func returns void), signal architecture (signal up call down), unique node access (%NodeName, @onready), script structure (extends, class_name, signals,

- **godot-gdscript-patterns** — `c:\getting_strange\.agents\skills\godot-gdscript-patterns`
  - Master Godot 4 GDScript patterns including signals, scenes, state machines, and optimization. Use when building Godot games, implementing game systems, or learning GDScript best practices.

- **godot-genre-action-rpg** — `c:\getting_strange\.agents\skills\godot-genre-action-rpg`
  - Comprehensive blueprint for Action RPGs including real-time combat (hitbox/hurtbox, stat-based damage), character progression (RPG stats, leveling, skill trees), loot systems (procedural item generation, affixes, rarity 

- **godot-genre-idle-clicker** — `c:\getting_strange\.agents\skills\godot-genre-idle-clicker`
  - Expert blueprint for idle/clicker games including big number handling (mantissa + exponent system), exponential growth curves (cost_growth_factor 1.15x), generator systems (auto-producers), offline progress calculation, 

- **godot-genre-platformer** — `c:\getting_strange\.agents\skills\godot-genre-platformer`
  - Expert blueprint for platformer games including precision movement (coyote time, jump buffering, variable jump height), game feel polish (squash/stretch, particle trails, camera shake), level design principles (difficult

- **godot-genre-simulation** — `c:\getting_strange\.agents\skills\godot-genre-simulation`
  - Expert blueprint for simulation and tycoon games (SimCity, RollerCoaster Tycoon, Factorio, Two Point Hospital) covering economy management, time progression, interconnected systems, NPC simulation, and feedback loops. Us

- **godot-genre-visual-novel** — `c:\getting_strange\.agents\skills\godot-genre-visual-novel`
  - Expert blueprint for visual novels (Doki Doki Literature Club, Phoenix Wright, Steins;Gate) focusing on branching narratives, dialogue systems, choice consequences, rollback mechanics, and persistent flags. Use when buil

- **godot-init** — `c:\getting_strange\.agents\skills\godot-init`
  - |

- **godot-input-handling** — `c:\getting_strange\.agents\skills\godot-input-handling`
  - Expert patterns for input handling covering InputMap actions, InputEvent processing, controller support, rebinding, deadzones, and input buffering. Use when setting up player controls, implementing input systems, or addi

- **godot-inventory-system** — `c:\getting_strange\.agents\skills\godot-inventory-system`
  - Expert blueprint for inventory systems (Diablo, Resident Evil, Minecraft) covering slot-based containers, stacking logic, weight limits, equipment systems, and drag-drop UI. Use when building RPG inventories, survival it

- **godot-live-edit** — `c:\getting_strange\.agents\skills\godot-live-edit`
  - Instantiate a scene as child

- **godot-master** — `c:\getting_strange\.agents\skills\godot-master`
  - Consolidated expert library for professional Godot 4.x game and application development. Orchestrates 94 specialized blueprints through architectural workflows, anti-pattern catalogs, performance budgets, and Server API 

- **godot-mechanic-secrets** — `c:\getting_strange\.agents\skills\godot-mechanic-secrets`
  - Use when implementing cheat codes, hidden interactions, or unlockable content based on player input/behavior.

- **godot-multiplayer** — `c:\getting_strange\.agents\skills\godot-multiplayer`
  - >

- **godot-nodes-scenes** — `c:\getting_strange\.agents\skills\godot-nodes-scenes`
  - >

- **godot-ops** — `c:\getting_strange\.agents\skills\godot-ops`
  - |

- **godot-optimization** — `c:\getting_strange\.agents\skills\godot-optimization`
  - Expert knowledge of Godot performance optimization, profiling, bottleneck identification, and optimization techniques. Use when helping improve game performance or analyzing performance issues.

- **godot-particles** — `c:\getting_strange\.agents\skills\godot-particles`
  - Expert blueprint for GPU particle systems (explosions, magic effects, weather, trails) using GPUParticles2D/3D, ParticleProcessMaterial, gradients, sub-emitters, and custom shaders. Use when creating VFX, environmental e

- **godot-performance-optimization** — `c:\getting_strange\.agents\skills\godot-performance-optimization`
  - Expert blueprint for performance profiling and optimization (frame drops, memory leaks, draw calls) using Godot Profiler, object pooling, visibility culling, and bottleneck identification. Use when diagnosing lag, optimi

- **godot-physics** — `c:\getting_strange\.agents\skills\godot-physics`
  - >

- **godot-platform-desktop** — `c:\getting_strange\.agents\skills\godot-platform-desktop`
  - Expert blueprint for desktop platforms (Windows/Linux/macOS) covering keyboard/mouse controls, settings menus, window management (fullscreen, resolution), keybind remapping, and Steam integration. Use when targeting PC p

- **godot-platform-mobile** — `c:\getting_strange\.agents\skills\godot-platform-mobile`
  - Expert blueprint for mobile platforms (Android/iOS) covering touch controls, virtual joysticks, responsive UI, safe areas (notches), battery optimization, and app store guidelines. Use when targeting mobile releases or i

- **godot-platform-web** — `c:\getting_strange\.agents\skills\godot-platform-web`
  - Expert blueprint for web/browser platforms (HTML5 export) covering WebGL/WebGPU rendering, custom loading screens, JavaScriptBridge integration, LocalStorage saves, and size optimization. Use when exporting to web or imp

- **godot-quest-system** — `c:\getting_strange\.agents\skills\godot-quest-system`
  - Expert blueprint for quest  tracking systems (objectives, progress, rewards, branching chains) using Resource-based quests, signal-driven updates, and AutoLoad managers. Use when implementing RPG quests or mission system

- **godot-resource-data-patterns** — `c:\getting_strange\.agents\skills\godot-resource-data-patterns`
  - Expert blueprint for data-oriented design using Resource/RefCounted classes (item databases, character stats, reusable data structures). Covers typed arrays, serialization, nested resources, and resource caching. Use whe

- **godot-resources** — `c:\getting_strange\.agents\skills\godot-resources`
  - >

- **godot-rpg-stats** — `c:\getting_strange\.agents\skills\godot-rpg-stats`
  - Expert blueprint for RPG stat systems (attributes, leveling, modifiers, damage formulas) using Resource-based stats, stackable modifiers, and derived stat calculations. Use when implementing character progression OR equi

- **godot-scene-management** — `c:\getting_strange\.agents\skills\godot-scene-management`
  - Expert blueprint for scene loading, transitions, async (background) loading, instance management, and caching. Covers fade transitions, loading screens, dynamic spawning, and scene persistence. Use when implementing leve

- **godot-shaders** — `c:\getting_strange\.agents\skills\godot-shaders`
  - >

- **godot-shaders-basics** — `c:\getting_strange\.agents\skills\godot-shaders-basics`
  - Expert blueprint for shader programming (visual effects, post-processing, material customization) using Godot's GLSL-like shader language. Covers canvas_item (2D), spatial (3D), uniforms, built-in variables, and performa

- **godot-signals-groups** — `c:\getting_strange\.agents\skills\godot-signals-groups`
  - >

- **godot-tilemap** — `c:\getting_strange\.agents\skills\godot-tilemap`
  - >

- **godot-turn-system** — `c:\getting_strange\.agents\skills\godot-turn-system`
  - Expert blueprint for turn-based combat with turn order, action points, phase management, and timeline systems for strategy/RPG games. Covers speed-based initiative, interrupts, and simultaneous turns. Use when implementi

- **godot-tweening** — `c:\getting_strange\.agents\skills\godot-tweening`
  - Expert blueprint for programmatic animation using Tween for smooth property transitions, UI effects, camera movements, and juice. Covers easing functions, parallel tweens, chaining, and lifecycle management. Use when imp

- **godot-ui** — `c:\getting_strange\.agents\skills\godot-ui`
  - Expert knowledge of Godot's UI system including Control nodes, themes, styling, responsive layouts, and common UI patterns for menus, HUDs, inventories, and dialogue systems. Use when working with Godot UI/menu creation 

- **godot-ui-containers** — `c:\getting_strange\.agents\skills\godot-ui-containers`
  - Expert blueprint for responsive UI layouts using Container nodes (HBoxContainer, VBoxContainer, GridContainer, MarginContainer, ScrollContainer). Covers size flags, anchors, split containers, and dynamic layouts. Use whe

- **godot-ui-control** — `c:\getting_strange\.agents\skills\godot-ui-control`
  - >

- **godot-ui-rich-text** — `c:\getting_strange\.agents\skills\godot-ui-rich-text`
  - Expert blueprint for RichTextLabel with BBCode formatting (bold, italic, colors, images, clickable links) and custom effects. Covers meta tags, RichTextEffect shaders, and dynamic content. Use when implementing dialogue 

- **godot-ui-theming** — `c:\getting_strange\.agents\skills\godot-ui-theming`
  - Expert blueprint for UI themes using Theme resources, StyleBoxes, custom fonts, and theme overrides for consistent visual styling. Covers StyleBoxFlat/Texture, theme inheritance, dynamic theme switching, and font variati

- **gpt-image-2** — `c:\getting_strange\.agents\skills\gpt-image-2`
  - >

- **graphic-design** — `c:\getting_strange\.agents\skills\graphic-design`
  - Professional graphic design principles for digital and print media. Use when creating visual designs, choosing color palettes, typography, layouts, or providing design feedback.

- **herald-events** — `c:\getting_strange\.agents\skills\herald-events`
  - Format eventów narracyjnych HERALD — JSON schema, typy efektów, zasady pisania. Aktywuj gdy tworzysz lub edytujesz pliki w data/events/.

- **herald-gdscript** — `c:\getting_strange\.agents\skills\herald-gdscript`
  - Wzorce GDScript dla projektu HERALD — Godot 4, izometryczne RPG. Aktywuj gdy piszesz skrypty .gd dla HERALD.

- **herald-narrative** — `c:\getting_strange\.agents\skills\herald-narrative`
  - Kontekst narracyjny gry HERALD — postacie, fabula, zakończenia. Aktywuj gdy piszesz dialogi, eventy, tekst UI, albo pracujesz z narracją.

- **herald-narrative-editor-codex-skill** — `c:\getting_strange\.agents\skills\herald-narrative-editor-codex-skill`
  - |

- **html-css** — `c:\getting_strange\.agents\skills\html-css`
  - Skill for html-css tasks.

- **ide-index-mcp** — `c:\getting_strange\.agents\skills\ide-index-mcp`
  - >

- **image-generation** — `c:\getting_strange\.agents\skills\image-generation`
  - Smaž raw/sheet soubory, nechej jen finální assety

- **imagegen** — `c:\getting_strange\.agents\skills\imagegen`
  - Generate or edit raster images when the task benefits from AI-created bitmap visuals such as photos, illustrations, textures, sprites, mockups, or transparent-background cutouts. Use when Codex should create a brand-new 

- **imagine** — `c:\getting_strange\.agents\skills\imagine`
  - Generate or edit images with Codex. Use this skill whenever the user says \"imagine ...\", asks to create an image from a text description, transform or restyle an existing image, produce artwork / illustrations / logos 

- **imagine-char** — `c:\getting_strange\.agents\skills\imagine-char`
  - 인디 게임·소설·TTRPG용 **게임 캐릭터 일러스트**를 **같은 캐릭터로 반복 생성**하도록 설계된 스킬. Character Card(JSON)를 기준으로 이름/종족/연령/헤어/눈/의상/구별 특징/아트 스타일/팔레트를 고정해두고, 대표 일러스트(portrait_hero) 1장을 reference로 삼아 turnaround·표정·포즈를 이어서 뽑는다. 사용자가 \"게임 캐릭터\", \"캐릭

- **imagine-empty** — `c:\getting_strange\.agents\skills\imagine-empty`
  - UI 엠프티 스테이트·에러·로딩·온보딩 일러스트를 **라이트/다크 쌍**으로 생성한다. 같은 모티프를 두 모드에 걸쳐 자연스럽게 보이게 하되, **단순 색 반전이 아니라 라이트·다크를 각각 별도 프롬프트로 분리 생성**한다. 프리셋 카탈로그는 `data/empty-states.json` 에 분리되어 커뮤니티 PR로 확장 가능. 투명 배경 PNG가 기본이며 alpha 채널을 검증한다. 사용자가

- **imagine-hero** — `c:\getting_strange\.agents\skills\imagine-hero`
  - SaaS · 개인 사이드 프로젝트의 **랜딩 페이지 히어로 이미지**를 3:2(1536×1024) 전용 프리셋으로 생성한다. 이미지 내부에 텍스트를 넣지 않고(모든 copy는 HTML이 담당), 한쪽 40%를 세이프존으로 비워 CTA·헤드라인을 얹을 수 있게 한다. `--transparent-bg` 플래그 지정 시 `scripts/lib/bg-remove.js`로 배경을 잘라낸 PNG도 함께

- **imagine-icon** — `c:\getting_strange\.agents\skills\imagine-icon`
  - 모바일 앱·웹 앱 **아이콘 세트 일괄 생성기**. AI로 1024×1024 마스터 아이콘을 뽑고, 플랫폼별 다중 해상도(iOS 1024 / Android adaptive 전경·배경 / Web favicon·PWA·Apple touch)를 `scripts/lib/icon-exporter.js`로 Lanczos3 리사이즈 익스포트한다. 사용자가 \"앱 아이콘\", \"imagine-icon\"

- **imagine-logo** — `c:\getting_strange\.agents\skills\imagine-logo`
  - 회사·개인 프로젝트·팀의 **로고 시안 탐색기**. 마크(심볼)만 Codex 이미지 모델로 생성하고 워드마크(회사명 글자)는 `scripts/lib/compose-text.js`로 합성한다. 회사명 텍스트는 AI 프롬프트에 **절대** 포함하지 않으며, 이미지 생성 후 OCR로 글자 검출 시 1회 자동 재생성한다. 3~6개의 서로 다른 방향성 시안을 한 번에 뽑아 \"나쁘지 않은 출발점\"을

- **imagine-mockup** — `c:\getting_strange\.agents\skills\imagine-mockup`
  - 앱스토어·포트폴리오·마케팅 자료에 쓰는 **제품 목업**(기기 프레임에 끼운 스크린샷 + 배경)을 생성한다. AI는 **배경만** 그리며, 기기 프레임과 스크린샷 합성은 `scripts/lib/device-composer.js`가 결정적으로 수행한다. 기기 프리셋은 `data/devices.json`에서 로드해 커뮤니티 PR로 확장 가능. 배경이 필요 없으면(solid/gradient/업로드

- **imagine-og** — `c:\getting_strange\.agents\skills\imagine-og`
  - 블로그·랜딩 글의 **OG 이미지 / 소셜 카드**(Twitter / Instagram / LinkedIn)를 플랫폼 프리셋에 맞춰 자동 생성한다. 배경 일러스트만 Codex 이미지 모델로 뽑고, 제목·태그 같은 글자는 AI에 맡기지 않고 공용 후처리 모듈(`scripts/lib/compose-text.js`)로 합성한다. 사용자가 \"OG 이미지\", \"소셜 카드\", \"imagine-

- **imagine-pattern** — `c:\getting_strange\.agents\skills\imagine-pattern`
  - 웹 배경·포장지·스티커·UI 텍스처용 **패턴/텍스처 이미지**를 두 모드로 생성한다. `seamless` 모드는 타일링 가능한 512/1024/2048 PNG를 만들고 `scripts/lib/seamless.js`로 (w/2, h/2) offset → 이음새 heal(feather blur + grain 재주입) → 4×4 타일링 프리뷰를 자동 산출한다. `large` 모드는 타일링 불필요

- **imagine-pixel** — `c:\getting_strange\.agents\skills\imagine-pixel`
  - 2D 도트 인디 게임·픽셀 아트 NFT·레트로 SNS 프로필용 **정수 픽셀 그리드 스프라이트**를 생성한다. AI가 뽑은 \"픽셀 스타일 이미지\"를 `scripts/lib/pixelize.js`로 **후처리 스냅**(nearest-neighbor 다운샘플 → 팔레트 클램프 → N× 업스케일)해 실제 16/32/48/64 그리드에 정렬한다. 스냅 없이 AI 원본을 그대로 저장하지 않는다. 

- **imagine-portrait** — `c:\getting_strange\.agents\skills\imagine-portrait`
  - 인물 사진을 **로컬에서만** 보정·변환하는 `edit.js` 확장 모드. 하위 모드로 `bg-swap`(배경 교체), `stylize`(수채/유화/아크릴/만화 변환), `restore`(노후 사진 복원), `group-tone`(단체 사진 톤 통일)을 제공한다. 모든 경로는 `./images/portraits/` 안으로 **강제**되며(output-allocator가 경로 탈출을 거절), 

- **imagine-poster** — `c:\getting_strange\.agents\skills\imagine-poster`
  - 밋업·컨퍼런스·학과 행사·사내 워크숍·Discord/Slack/카톡 공지용 **이벤트 포스터/홍보물**을 생성한다. 배경과 장식 모티프만 Codex 이미지 모델로 뽑고, 제목·부제·날짜·장소·연사·CTA 같은 **정보 텍스트는 YAML/JSON 입력**을 받아 `scripts/lib/poster-layouter.js`가 결정적 레이아웃으로 합성한다. 포스터(3:4.24 A4)·배너(16:9)

- **imagine-sprite** — `c:\getting_strange\.agents\skills\imagine-sprite`
  - `imagine-pixel`로 만든 캐릭터의 **애니메이션 스프라이트 시트**를 Unity/Godot/Aseprite가 바로 import할 수 있는 포맷으로 생성한다. 프레임은 **프레임 단위 개별 호출**로 뽑고, 첫 프레임을 **image→image reference**로 삼아 연속 프레임의 의상·머리색·팔레트가 드리프트하지 않도록 한다. `scripts/lib/pixelize.js`로 

- **imagine-thumb** — `c:\getting_strange\.agents\skills\imagine-thumb`
  - YouTube 썸네일 전용 생성기. 배경/인물 일러스트는 Codex 이미지 모델로 뽑고, 제목 텍스트는 **AI가 아니라 Node 후처리**(`scripts/lib/compose-text.js`)로 합성한다. 한국어 글자 깨짐을 원천 차단한다. 사용자가 \"썸네일 만들어줘\", \"imagine-thumb <제목>\", \"유튜브 썸네일\" 등을 말하면 이 스킬이 담당한다. 기본 A/B용 2

- **imagine-ui** — `c:\getting_strange\.agents\skills\imagine-ui`
  - 모바일 앱 화면의 **스타일 레퍼런스 이미지**를 빠르게 뽑는다. 실제 픽셀 퍼펙트 UI·구현 가능한 디자인이 아니라, Figma를 켜기 전에 \"대충 이런 느낌인가?\"를 여러 장 나열해보기 위한 **무드 보드**다. iOS · Android Material 3 · 한국 fintech(Pretendard 스타일) · 웹 모바일 프리셋을 제공하고, Style Guardian manifest에

- **implementing-gameplay-invariants** — `c:\getting_strange\.agents\skills\implementing-gameplay-invariants`
  - Translates game design prose into engine-neutral implementation invariants and validation checks. Use when implementing or reviewing game mechanics where idle, hold-only, mashing, spam, safe waiting, or repeated scoring 

- **improve-agent** — `c:\getting_strange\.agents\skills\improve-agent`
  - Systematic improvement of existing agents through performance analysis, prompt engineering, and continuous iteration.

- **improve-game** — `c:\getting_strange\.agents\skills\improve-game`
  - Analyze a game, find what needs work, and implement the highest-impact improvements. Use when the user says \"improve my game\", \"make my game better\", \"fix my game\", \"what's wrong with my game\", or \"polish my gam

- **index** — `c:\getting_strange\.agents\skills\index`
  - Skill for index tasks.

- **input-systems** — `c:\getting_strange\.agents\skills\input-systems`
  - >

- **layout** — `c:\getting_strange\.agents\skills\layout`
  - Improve layout, spacing, and visual rhythm. Fixes monotonous grids, inconsistent spacing, and weak visual hierarchy. Use when the user mentions layout feeling off, spacing issues, visual hierarchy, crowded UI, alignment 

- **level-design** — `c:\getting_strange\.agents\skills\level-design`
  - >

- **lightweight-3d-effects** — `c:\getting_strange\.agents\skills\lightweight-3d-effects`
  - Lightweight 3D effects for decorative elements and micro-interactions using Zdog, Vanta.js, and Vanilla-Tilt.js. Use this skill when adding pseudo-3D illustrations, animated backgrounds, parallax tilt effects, decorative

- **make-game** — `c:\getting_strange\.agents\skills\make-game`
  - Use when the user wants to design, scaffold, build, or iterate on a video game — including brainstorming new game ideas, planning a gameplay loop, choosing an engine, scaffolding a project, adding features, fixing gamepl

- **maximizing-game-feel** — `c:\getting_strange\.agents\skills\maximizing-game-feel`
  - Improves the tactile satisfaction (\"game feel\") of action games whose visuals are functional but flat. Use when a game runs correctly but feels lifeless; applies to players, enemies, obstacles, projectiles, and items.

- **MCP Integration** — `c:\getting_strange\.agents\skills\MCP Integration`
  - This skill should be used when the user asks to \"add MCP server\", \"integrate MCP\", \"configure MCP in plugin\", \"use .mcp.json\", \"set up Model Context Protocol\", \"connect external service\", mentions \"${CLAUDE_

- **memory-management** — `c:\getting_strange\.agents\skills\memory-management`
  - >

- **meshyai** — `c:\getting_strange\.agents\skills\meshyai`
  - Generate custom 3D models from text or images using Meshy AI, then auto-rig and animate them for Three.js games. The preferred source for all 3D game assets. Use when the user says \"generate a 3D model\", \"create a cha

- **microinteraction-patterns** — `c:\getting_strange\.agents\skills\microinteraction-patterns`
  - Skill for microinteraction-patterns tasks.

- **mobile-accessibility** — `c:\getting_strange\.agents\skills\mobile-accessibility`
  - Skill for mobile-accessibility tasks.

- **mobile-android-design** — `c:\getting_strange\.agents\skills\mobile-android-design`
  - Master Material Design 3 and Jetpack Compose patterns for building native Android apps. Use when designing Android interfaces, implementing Compose UI, or following Google's Material Design guidelines.

- **mobile-developer** — `c:\getting_strange\.agents\skills\mobile-developer`
  - Develop React Native, Flutter, or native mobile apps with modern architecture patterns. Masters cross-platform development, native integrations, offline sync, and app store optimization. Use PROACTIVELY for mobile featur

- **mobile-security-coder** — `c:\getting_strange\.agents\skills\mobile-security-coder`
  - Expert in secure mobile coding practices specializing in input validation, WebView security, and mobile-specific security patterns. Use PROACTIVELY for mobile security implementations or mobile security code reviews.

- **modern-web-design** — `c:\getting_strange\.agents\skills\modern-web-design`
  - Modern web design trends, principles, and implementation patterns for 2024-2025. Use this skill when designing websites, creating interactive experiences, implementing design systems, ensuring accessibility, or building 

- **monetize-game** — `c:\getting_strange\.agents\skills\monetize-game`
  - Register your game on Play.fun (OpenGameProtocol), add the browser SDK, and get a monetized play.fun URL. Use when the user says \"monetize my game\", \"add Play.fun\", \"add rewards\", \"register on Play.fun\", or \"get

- **motion-framer** — `c:\getting_strange\.agents\skills\motion-framer`
  - Modern animation library for React and JavaScript. Create smooth, production-ready animations with motion components, variants, gestures (hover/tap/drag), layout animations, AnimatePresence exit animations, spring physic

- **multi-channel-bundle** — `c:\getting_strange\.agents\skills\multi-channel-bundle`
  - Ship a coordinated multi-format asset bundle for any push.

- **multi-platform** — `c:\getting_strange\.agents\skills\multi-platform`
  - Build and deploy the same feature consistently across web, mobile, and desktop platforms using API-first architecture and parallel implementation strategies.

- **mystery-novel-conventions** — `c:\getting_strange\.agents\skills\mystery-novel-conventions`
  - Use when user mentions mystery, detective, crime, or suspense-focused narrative - provides genre conventions, clue placement, and fair play principles for mystery writing

- **narrative-conductor** — `c:\getting_strange\.agents\skills\narrative-conductor`
  - Définit l'arc narratif complet et valide la cohérence narrative pour les épisodes NEW TEMPS X. Utilise ce Skill quand tu dois créer ou valider un arc narratif structuré en 7 actes, ou vérifier qu'un épisode respecte la s

- **natural-dialogue-techniques** — `c:\getting_strange\.agents\skills\natural-dialogue-techniques`
  - Use when writing dialogue scenes or when user asks about character conversations - provides techniques for natural, character-consistent dialogue that reveals character and advances plot

- **novel-architect** — `c:\getting_strange\.agents\skills\novel-architect`
  - |

- **novel-creator** — `c:\getting_strange\.agents\skills\novel-creator`
  - |

- **novel-writer-workflow-guide** — `c:\getting_strange\.agents\skills\novel-writer-workflow-guide`
  - Use when user starts a novel project or asks how to organize their writing - guides through novel-writer's seven-step methodology and ensures proper workflow

- **ocr-document-processor** — `c:\getting_strange\.agents\skills\ocr-document-processor`
  - Extract text and structure from scans, images, and scanned PDFs. Use for OCR, searchable PDFs, table extraction, receipt parsing, and business card parsing.

- **onboard** — `c:\getting_strange\.agents\skills\onboard`
  - You are an **expert onboarding specialist and knowledge transfer architect** with deep experience in remote-first organizations, technical team integration, and accelerated learning methodologies. Your role is to ensure 

- **optimize** — `c:\getting_strange\.agents\skills\optimize`
  - Diagnoses and fixes UI performance across loading speed, rendering, animations, images, and bundle size. Use when the user mentions slow, laggy, janky, performance, bundle size, load time, or wants a faster, smoother exp

- **pdf-ocr-extraction** — `c:\getting_strange\.agents\skills\pdf-ocr-extraction`
  - Extract text from scanned PDFs using optical character recognition

- **performance-optimization** — `c:\getting_strange\.agents\skills\performance-optimization`
  - >

- **phaser** — `c:\getting_strange\.agents\skills\phaser`
  - >

- **phaser-gamedev** — `c:\getting_strange\.agents\skills\phaser-gamedev`
  - Build 2D browser games with Phaser 3 (JS/TS): scenes, sprites, physics (Arcade/Matter), tilemaps (Tiled), animations, input. Trigger: 'Phaser scene', 'Arcade physics', 'tilemap', 'Phaser 3 game'.

- **php-pro** — `c:\getting_strange\.agents\skills\php-pro`
  - Write idiomatic PHP code with generators, iterators, SPL data structures, and modern OOP features. Use PROACTIVELY for high-performance PHP applications.

- **physics-tuning** — `c:\getting_strange\.agents\skills\physics-tuning`
  - >

- **pixelart-cleanup** — `c:\getting_strange\.agents\skills\pixelart-cleanup`
  - Use when the user wants to clean halo fragments or

- **pixellab** — `c:\getting_strange\.agents\skills\pixellab`
  - Stitch into WebP

- **pixellab-api** — `c:\getting_strange\.agents\skills\pixellab-api`
  - Recolor

- **pixijs-2d** — `c:\getting_strange\.agents\skills\pixijs-2d`
  - Fast, lightweight 2D rendering engine for creating interactive graphics, particle effects, and canvas-based applications using WebGL/WebGPU. Use this skill when building 2D games, particle systems, interactive canvases, 

- **pixijs-scene-graphics** — `c:\getting_strange\.agents\skills\pixijs-scene-graphics`
  - Use this skill when drawing vector shapes and paths in PixiJS v8. Covers the Graphics API: shape-then-fill methods (rect/circle/ellipse/poly/roundRect/star/regularPoly/roundPoly/roundShape/filletRect/chamferRect), path m

- **planning-and-task-breakdown** — `c:\getting_strange\.agents\skills\planning-and-task-breakdown`
  - Breaks work into ordered tasks. Use when you have a spec or clear requirements and need to break work into implementable tasks. Use when a task feels too large to start, when you need to estimate scope, or when parallel 

- **player-ux** — `c:\getting_strange\.agents\skills\player-ux`
  - Cognitive load management for players: perception/attention/memory framework, Gestalt principles for game UI, signal-noise discipline on the HUD, onboarding ramp design, and tooltip/affordance patterns. Use when designin

- **playstore-submission-content** — `c:\getting_strange\.agents\skills\playstore-submission-content`
  - Generate ready-to-paste Google Play Store text content for Android app submissions. Analyzes project context and produces all required text fields with Play Store character rules enforced.

- **Plugin Settings** — `c:\getting_strange\.agents\skills\Plugin Settings`
  - This skill should be used when the user asks about \"plugin settings\", \"store plugin configuration\", \"user-configurable plugin\", \".local.md files\", \"plugin state files\", \"read YAML frontmatter\", \"per-project 

- **polish** — `c:\getting_strange\.agents\skills\polish`
  - Performs a final quality pass fixing alignment, spacing, consistency, and micro-detail issues before shipping. Use when the user mentions polish, finishing touches, pre-launch review, something looks off, or wants to go 

- **polska-proza-gamedev2** — `c:\getting_strange\.agents\skills\polska-proza-gamedev2`
  - |

- **pre-write-checklist** — `c:\getting_strange\.agents\skills\pre-write-checklist`
  - Activates automatically before chapter writing to enforce the 9-item mandatory file reading checklist - prevents AI focus degradation in long-form fiction by ensuring all context is loaded before each writing session

- **procedural-gen** — `c:\getting_strange\.agents\skills\procedural-gen`
  - >

- **promo-video** — `c:\getting_strange\.agents\skills\promo-video`
  - >

- **prompt-engineer** — `c:\getting_strange\.agents\skills\prompt-engineer`
  - Expert prompt engineer specializing in advanced prompting techniques, LLM optimization, and AI system design. Masters chain-of-thought, constitutional AI, and production prompt strategies. Use when building AI features, 

- **prompt-optimization** — `c:\getting_strange\.agents\skills\prompt-optimization`
  - Skill for prompt-optimization tasks.

- **prompt-optimize** — `c:\getting_strange\.agents\skills\prompt-optimize`
  - Optimize prompts for production with CoT, few-shot, and constitutional AI patterns

- **prompt-template-library** — `c:\getting_strange\.agents\skills\prompt-template-library`
  - Skill for prompt-template-library tasks.

- **prompt-templates** — `c:\getting_strange\.agents\skills\prompt-templates`
  - Skill for prompt-templates tasks.

- **psych-accessibility** — `c:\getting_strange\.agents\skills\psych-accessibility`
  - Accessibility and inclusivity validation for game development. Invoked by game-psychologist agent at validation checkpoints. Applies UDL, WCAG, Sensory Processing Theory, neurodiversity considerations, and cultural sensi

- **psych-behavioral** — `c:\getting_strange\.agents\skills\psych-behavioral`
  - Behavioral design validation for game development. Invoked by game-psychologist agent at validation checkpoints. Applies Fogg Behavior Model, Hook Model (Nir Eyal), Nudge Theory, Habit Formation, and Session Design to va

- **psych-developmental** — `c:\getting_strange\.agents\skills\psych-developmental`
  - Developmental psychology validation for game development. Invoked by game-psychologist agent at validation checkpoints. Applies Erikson's Stages, Gardner's Multiple Intelligences, Executive Function Development, and Piag

- **psych-learning** — `c:\getting_strange\.agents\skills\psych-learning`
  - Cognitive and learning science validation for game development. Invoked by game-psychologist agent at validation checkpoints. Applies Bloom's Taxonomy, Piaget, Vygotsky ZPD, Dual Coding, Multimedia Learning, and Spaced R

- **psych-motivation** — `c:\getting_strange\.agents\skills\psych-motivation`
  - Motivation and engagement validation for game development. Invoked by game-psychologist agent at validation checkpoints. Applies Self-Determination Theory, Flow Theory, Expectancy-Value, Attribution Theory, and Operant C

- **qa-game** — `c:\getting_strange\.agents\skills\qa-game`
  - Add Playwright QA tests to a game — visual regression, gameplay verification, and performance. Use when the user says \"add tests\", \"test my game\", \"add QA\", \"check for bugs\", or \"add visual regression tests\". D

- **quick-game** — `c:\getting_strange\.agents\skills\quick-game`
  - Rapidly scaffold and implement a playable game — no assets, design, audio, deploy, or monetize. Get something on screen fast. Use when the user says \"quick game\", \"fast prototype\", \"just get something playable\", or

- **README** — `c:\getting_strange\.agents\skills\README`
  - Skill for README tasks.

- **record-promo** — `c:\getting_strange\.agents\skills\record-promo`
  - Record an autonomous 50 FPS promo video of your game for social media. Use when the user says \"record a video\", \"make a promo\", \"capture gameplay\", \"record gameplay footage\", or \"make a trailer for my game\". Do

- **requirement-detector** — `c:\getting_strange\.agents\skills\requirement-detector`
  - 探测用户的写作规范需求并加载对应文档。当用户提到AI味重、去AI味、自然、爽文、快节奏、爽点、无毒点、不降智、严肃文学、有深度、强情绪、打动人、甜文、撒糖、虐文、虐心、BE等关键词时自动激活。适用于讨论写作要求、AI去味方法、节奏控制、情感表达时使用。

- **research** — `c:\getting_strange\.agents\skills\research`
  - Fast agent specialized for exploring codebases and searching for code patterns. Use via spawn_subagent with skill='research' for read-only exploration tasks.

- **rest-best-practices** — `c:\getting_strange\.agents\skills\rest-best-practices`
  - Skill for rest-best-practices tasks.

- **retro-analyze** — `c:\getting_strange\.agents\skills\retro-analyze`
  - Retrospective analysis. Derives root cause, lessons, and rule changes from observations. Invoked by game-retrospective agent. Uses 5 Whys and fishbone analysis.

- **retro-govern** — `c:\getting_strange\.agents\skills\retro-govern`
  - Retrospective governance. Scopes, validates, assigns, and tracks retrospective findings. Manages the feedback loop — approved lessons flow into lessons-learned.md for reinforcement learning.

- **retro-observe** — `c:\getting_strange\.agents\skills\retro-observe`
  - Retrospective data collection. Gathers observation, impact, and evidence for retrospective analysis. Invoked by game-retrospective agent. Documents facts without interpretation.

- **retrodiffusion** — `c:\getting_strange\.agents\skills\retrodiffusion`
  - Generate true pixel art sprites, tilesets, and animations with the Retro Diffusion API — the best dedicated pixel art model. Use when the user says \"generate pixel art\", \"make a sprite with AI\", \"use Retro Diffusion

- **review-game** — `c:\getting_strange\.agents\skills\review-game`
  - Review an existing game codebase for architecture, performance, and best practices. Use when the user says \"review my game\", \"code review\", \"check my game architecture\", \"is my game well structured\", or \"audit m

- **save-systems** — `c:\getting_strange\.agents\skills\save-systems`
  - >

- **scaffold-gateables** — `c:\getting_strange\.agents\skills\scaffold-gateables`
  - Add gateable features to an existing browser game — skin picker, continue-after-death, bonus mode, save slots, daily challenge. Monetization-agnostic scaffolding that leaves clean hooks for any paywall, subscription, or 

- **scene-structure-techniques** — `c:\getting_strange\.agents\skills\scene-structure-techniques`
  - Use when structuring scenes or planning chapter content - provides scene-sequel framework, tension management, and beat-by-beat structure for compelling scenes

- **scroll-animations** — `c:\getting_strange\.agents\skills\scroll-animations`
  - Skill for scroll-animations tasks.

- **search-specialist** — `c:\getting_strange\.agents\skills\search-specialist`
  - Expert web researcher using advanced search techniques and synthesis. Masters search operators, result filtering, and multi-source verification. Handles competitive analysis and fact-checking. Use PROACTIVELY for deep re

- **security-auditor** — `c:\getting_strange\.agents\skills\security-auditor`
  - Expert security auditor specializing in DevSecOps, comprehensive cybersecurity, and compliance frameworks. Masters vulnerability assessment, threat modeling, secure authentication (OAuth2/OIDC), OWASP standards, cloud se

- **self-evolving-agent** — `c:\getting_strange\.agents\skills\self-evolving-agent`
  - Darwin Gödel Machine patterns for self-improving AI agents with open-ended code evolution. Use for building agents that autonomously improve their own capabilities, modify their codebases, and evolve through interaction.

- **serio-po-polsku** — `c:\getting_strange\.agents\skills\serio-po-polsku`
  - Audytuj, poprawiaj i redaguj polski tekst widoczny dla człowieka, w tym mikrocopy i frontend/i18n, artykuły, raporty, dokumentację, dialog, prozę oraz książki; usuwaj rzeczywistą schematyczność, kalki i nienaturalny styl

- **setting-detector** — `c:\getting_strange\.agents\skills\setting-detector`
  - Automatically detects story settings (genres, time periods, themes) based on keywords and activates corresponding knowledge bases - works silently in the background to provide relevant writing guidance without user inter

- **setup** — `c:\getting_strange\.agents\skills\setup`
  - Initialize project with Conductor artifacts (product definition, tech stack, workflow, style guides)

- **shader-programming** — `c:\getting_strange\.agents\skills\shader-programming`
  - >

- **shape** — `c:\getting_strange\.agents\skills\shape`
  - Plan the UX and UI for a feature before writing code. Runs a structured discovery interview, then produces a design brief that guides implementation. Use during the planning phase to establish design direction, constrain

- **SKILL** — `c:\getting_strange\.agents\skills\SKILL`
  - Master React, Vue, and Svelte component patterns including CSS-in-JS, composition strategies, and reusable component architecture. Use when building UI component libraries, designing component APIs, or implementing front

- **skill-creator** — `c:\getting_strange\.agents\skills\skill-creator`
  - Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Codex's capabilities with specialized knowledge, workflows, or tool integrat

- **skill-evolution** — `c:\getting_strange\.agents\skills\skill-evolution`
  - Patterns for evolutionarily robust skills that adapt across agent generations. Darwin-Godel machine principles for self-improving skill ecosystems.

- **skill-improver** — `c:\getting_strange\.agents\skills\skill-improver`
  - Iteratively reviews and fixes Codex skill quality issues until they meet standards. Runs automated fix-review cycles using the skill-reviewer agent. Use to fix skill quality issues, improve skill descriptions, run automa

- **skill-installer** — `c:\getting_strange\.agents\skills\skill-installer`
  - Install Codex skills into $CODEX_HOME/skills from a curated list or a GitHub repo path. Use when a user asks to list installable skills, install a curated skill, or install a skill from another repo (including private re

- **skill-loader** — `c:\getting_strange\.agents\skills\skill-loader`
  - Dynamic skill loading via polynomial functor arrangements. Loads skills as interfaces p = A^y^B where state changes rewire the system.

- **skill-maker-ai-skill-factory-for-tools** — `c:\getting_strange\.agents\skills\skill-maker-ai-skill-factory-for-tools`
  - Meta-skill that generates domain-specific AI skills from tool documentation

- **smart-debug** — `c:\getting_strange\.agents\skills\smart-debug`
  - You are an expert AI-assisted debugging specialist with deep knowledge of modern debugging tools, observability platforms, and automated root cause analysis.

- **smart-fix** — `c:\getting_strange\.agents\skills\smart-fix`
  - [Extended thinking: This workflow implements a sophisticated debugging and resolution pipeline that leverages AI-assisted debugging tools and observability platforms to systematically diagnose and resolve production issu

- **smart-ocr** — `c:\getting_strange\.agents\skills\smart-ocr`
  - >

- **spacing-iconography** — `c:\getting_strange\.agents\skills\spacing-iconography`
  - Skill for spacing-iconography tasks.

- **status** — `c:\getting_strange\.agents\skills\status`
  - Display project status, active tracks, and next actions

- **story** — `c:\getting_strange\.agents\skills\story`
  - 网络小说工具箱主入口。根据用户需求自动路由到对应 skill；当用户意图不明确时触发，由路由逻辑分发到具体的扫榜/拆文/写作/去AI味/封面/导入/审查 skill。触发方式：/story、$story、/网文、「我想写小说」「帮我写书」「写网文」「检查更新」「有新版本吗」。

- **story-consistency-monitor** — `c:\getting_strange\.agents\skills\story-consistency-monitor`
  - Use during chapter writing to automatically check character behavior, world rules, and timeline consistency - alerts when detecting potential contradictions before they become major issues

- **story-deslop** — `c:\getting_strange\.agents\skills\story-deslop`
  - 网文去AI味。检测并清除文本中的AI写作痕迹，让文字回归自然、非模板化。触发方式：/story-deslop、/去AI味、「去AI味」「这篇太AI了」「网文去AI味」。

- **story-long-analyze** — `c:\getting_strange\.agents\skills\story-long-analyze`
  - 长篇网文拆文。深度拆解爆款长篇小说的黄金三章、人设架构、爽点设计、节奏控制。单一深度拆解管道：跑完黄金三章（Stage 1）后产出快速预览报告并询问是否继续全量拆解，确认后从 Stage 2 续跑逐章摘要、聚合分析、设定关系、汇总报告，全程产物落盘 拆文库/{书名}/。触发方式：/story-long-analyze、/长篇拆文、「帮我拆这本书」「拆这本书」「分析黄金三章」「深度拆解」「完整拆解」「系统拆解」或提供小说文本文件路径——全

- **story-long-scan** — `c:\getting_strange\.agents\skills\story-long-scan`
  - 长篇网文扫榜。分析起点、番茄、晋江等平台排行榜数据，提炼市场趋势与热门题材。触发方式：/story-long-scan、/长篇扫榜、「长篇什么火」「起点排行」。

- **story-long-write** — `c:\getting_strange\.agents\skills\story-long-write`
  - 长篇网文写作。从大纲到正文，辅助长篇网络小说的创作，包括世界观、人物、情节线管理。触发方式：/story-long-write、/写长篇、「帮我开书」「写大纲」「日更」「续写」「继续写」「修改第X章」「回炉」「重写第X章」。

- **story-review** — `c:\getting_strange\.agents\skills\story-review`
  - |

- **story-setup** — `c:\getting_strange\.agents\skills\story-setup`
  - |

- **story-short-analyze** — `c:\getting_strange\.agents\skills\story-short-analyze`
  - |

- **story-short-scan** — `c:\getting_strange\.agents\skills\story-short-scan`
  - |

- **story-short-write** — `c:\getting_strange\.agents\skills\story-short-write`
  - |

- **storytelling-expert** — `c:\getting_strange\.agents\skills\storytelling-expert`
  - This skill should be used when the user needs to transform ideas, presentations, speeches, or data into persuasive stories using elite storytelling frameworks.

- **style-detector** — `c:\getting_strange\.agents\skills\style-detector`
  - 探测用户的写作风格需求并加载对应指南。当用户提到口语化、生活化、真实感、文学性、严肃文学、纯文学、网文、爽文、快节奏、古风、武侠、古韵、极简、海明威、克制等关键词时自动激活。适用于讨论小说风格、写作文风、创作方向时使用。

- **styling-patterns** — `c:\getting_strange\.agents\skills\styling-patterns`
  - Skill for styling-patterns tasks.

- **styling-web-game-typography** — `c:\getting_strange\.agents\skills\styling-web-game-typography`
  - Implements readable, licensed typography for distributed games (web export, downloadable, packaged). Use when defining theme-based text roles, adopting fonts, handling font licenses for redistribution, or checking HUD re

- **substance-3d-texturing** — `c:\getting_strange\.agents\skills\substance-3d-texturing`
  - Comprehensive skill for Adobe Substance 3D Painter texturing and material creation workflow. Use this skill when creating PBR materials, exporting textures for web/game engines, optimizing 3D assets for real-time renderi

- **system-prompts** — `c:\getting_strange\.agents\skills\system-prompts`
  - Skill for system-prompts tasks.

- **text-to-visual** — `c:\getting_strange\.agents\skills\text-to-visual`
  - Generate matching visuals from text via Picsart gen-ai.

- **theming-architecture** — `c:\getting_strange\.agents\skills\theming-architecture`
  - Skill for theming-architecture tasks.

- **threat-modeling-expert** — `c:\getting_strange\.agents\skills\threat-modeling-expert`
  - Threat Modeling Expert

- **threejs-game** — `c:\getting_strange\.agents\skills\threejs-game`
  - Build 3D browser games with Three.js using event-driven modular architecture. Use when creating a new 3D game, adding 3D game features, setting up Three.js scenes, or working on any Three.js game project.

- **threejs-perf** — `c:\getting_strange\.agents\skills\threejs-perf`
  - Three.js performance optimization patterns for draw calls, scene traversal, and instancing. Use when optimizing 3D scenes with 100+ repeated objects, thousands of moving entities, or draw calls above 500. Loaded by three

- **threejs-webgl** — `c:\getting_strange\.agents\skills\threejs-webgl`
  - Comprehensive skill for Three.js 3D web development. Use this skill when building interactive 3D scenes, WebGL/WebGPU applications, product configurators, 3D visualizations, or immersive web experiences. Triggers on task

- **track-plan** — `c:\getting_strange\.agents\skills\track-plan`
  - Skill for track-plan tasks.

- **track-spec** — `c:\getting_strange\.agents\skills\track-spec`
  - Skill for track-spec tasks.

- **tutorial-engineer** — `c:\getting_strange\.agents\skills\tutorial-engineer`
  - Creates step-by-step tutorials and educational content from code. Transforms complex concepts into progressive learning experiences with hands-on examples. Use PROACTIVELY for onboarding guides, feature tutorials, or con

- **ui-designer** — `c:\getting_strange\.agents\skills\ui-designer`
  - Expert UI designer specializing in component creation, layout systems, and visual design implementation. Masters modern design patterns, responsive layouts, and design-to-code workflows. Use PROACTIVELY when building UI 

- **ui-ux-designer** — `c:\getting_strange\.agents\skills\ui-ux-designer`
  - Create interface designs, wireframes, and design systems. Masters user research, accessibility standards, and modern design tools. Specializes in design tokens, component libraries, and inclusive design. Use PROACTIVELY 

- **ui-visual-validator** — `c:\getting_strange\.agents\skills\ui-visual-validator`
  - Rigorous visual validation expert specializing in UI testing, design system compliance, and accessibility verification. Masters screenshot analysis, visual regression testing, and component validation. Use PROACTIVELY to

- **use-template** — `c:\getting_strange\.agents\skills\use-template`
  - Clone a game template from the gallery as a starting point. Use when the user says \"use a template\", \"start from a template\", \"clone flappy-bird\", \"use the platformer template\", or wants to quickly bootstrap a ga

- **using-agent-skills** — `c:\getting_strange\.agents\skills\using-agent-skills`
  - Discovers and invokes agent skills. Use when starting a session or when you need to discover which skill applies to the current task. This is the meta-skill that governs how all other skills are discovered and invoked.

- **using-godot-prompter** — `c:\getting_strange\.agents\skills\using-godot-prompter`
  - Bootstrap skill — establishes how to find and use GodotPrompter skills, with platform-specific tool mapping

- **using-superpowers** — `c:\getting_strange\.agents\skills\using-superpowers`
  - Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions

- **v3-cli-modernization** — `c:\getting_strange\.agents\skills\v3-cli-modernization`
  - CLI modernization and hooks system enhancement for Codex-flow v3. Implements interactive prompts, command decomposition, enhanced hooks integration, and intelligent workflow automation.

- **v3-core-implementation** — `c:\getting_strange\.agents\skills\v3-core-implementation`
  - Core module implementation for Codex-flow v3. Implements DDD domains, clean architecture patterns, dependency injection, and modular TypeScript codebase with comprehensive testing.

- **v3-ddd-architecture** — `c:\getting_strange\.agents\skills\v3-ddd-architecture`
  - Domain-Driven Design architecture for Codex-flow v3. Implements modular, bounded context architecture with clean separation of concerns and microkernel pattern.

- **v3-integration-deep** — `c:\getting_strange\.agents\skills\v3-integration-deep`
  - Deep agentic-flow@alpha integration implementing ADR-001. Eliminates 10,000+ duplicate lines by building Codex-flow as specialized extension rather than parallel implementation.

- **v3-mcp-optimization** — `c:\getting_strange\.agents\skills\v3-mcp-optimization`
  - MCP server optimization and transport layer enhancement for Codex-flow v3. Implements connection pooling, load balancing, tool registry optimization, and performance monitoring for sub-100ms response times.

- **v3-memory-unification** — `c:\getting_strange\.agents\skills\v3-memory-unification`
  - Unify 6+ memory systems into AgentDB with HNSW indexing for 150x-12,500x search improvements. Implements ADR-006 (Unified Memory Service) and ADR-009 (Hybrid Memory Backend).

- **v3-performance-optimization** — `c:\getting_strange\.agents\skills\v3-performance-optimization`
  - Achieve aggressive v3 performance targets: 2.49x-7.47x Flash Attention speedup, 150x-12,500x search improvements, 50-75% memory reduction. Comprehensive benchmarking and optimization suite.

- **v3-security-overhaul** — `c:\getting_strange\.agents\skills\v3-security-overhaul`
  - Complete security architecture overhaul for Codex-flow v3. Addresses critical CVEs (CVE-1, CVE-2, CVE-3) and implements secure-by-default patterns. Use for security-first v3 implementation.

- **v3-swarm-coordination** — `c:\getting_strange\.agents\skills\v3-swarm-coordination`
  - 15-agent hierarchical mesh coordination for v3 implementation. Orchestrates parallel execution across security, core, and integration domains following 10 ADRs with 14-week timeline.

- **verifying-turn-based-games** — `c:\getting_strange\.agents\skills\verifying-turn-based-games`
  - Verifies two-player strict-alternating-turn games via a pure-function engine contract and bot-ladder / WP-tension metrics. Use when designing or implementing board/card games that need replay, search, bot ladders, win-ra

- **video-motion-graphics** — `c:\getting_strange\.agents\skills\video-motion-graphics`
  - Use when creating After Effects compositions, Premiere Pro motion, video titles, explainer videos, or broadcast motion graphics.

- **viral-game** — `c:\getting_strange\.agents\skills\viral-game`
  - One-shot viral game pipeline — turn a tweet, news story, or short prompt into a scaffolded, designed, deployed, and monetized browser game in roughly 10 minutes. Use when the user says \"make a viral game\", \"build a ga

- **vite** — `c:\getting_strange\.agents\skills\vite`
  - Vite build tool configuration, plugin API, SSR, and Vite 8 Rolldown migration. Use when working with Vite projects, vite.config.ts, Vite plugins, or building libraries/SSR apps with Vite.

- **vite-deployment** — `c:\getting_strange\.agents\skills\vite-deployment`
  - Vite SPA deployment to various platforms. Use when deploying React SPAs.

- **web3d-integration-patterns** — `c:\getting_strange\.agents\skills\web3d-integration-patterns`
  - Meta-skill for combining Three.js, GSAP ScrollTrigger, React Three Fiber, Motion, and React Spring for complex 3D web experiences. Use when building applications that integrate multiple 3D and animation libraries, requir

- **webapp-testing** — `c:\getting_strange\.agents\skills\webapp-testing`
  - Toolkit for interacting with and testing local web applications using

- **webnovel-write** — `c:\getting_strange\.agents\skills\webnovel-write`
  - 产出可发布章节，完整执行上下文→起草→审查→润色→提交→备份。

- **workflow** — `c:\getting_strange\.agents\skills\workflow`
  - Skill for workflow tasks.

- **workflow-automate** — `c:\getting_strange\.agents\skills\workflow-automate`
  - You are a workflow automation expert specializing in creating efficient CI/CD pipelines, GitHub Actions workflows, and automated development processes. Design and implement automation that reduces manual work, improves c

- **worldlabs** — `c:\getting_strange\.agents\skills\worldlabs`
  - Generate photorealistic 3D worlds and environments with the World Labs Marble API — Gaussian Splat scenes from text prompts or reference images. Use when the user says \"generate a 3D world\", \"create an environment\", 

### User-scoped

- **adopt** — `C:\Users\admin\.copilot\skills\adopt`
  - Brownfield onboarding — audits existing project artifacts for template format compliance (not just existence), classifies gaps by impact, and produces a numbered migration plan. Run this when joining an in-progress proje

- **architecture-decision** — `C:\Users\admin\.copilot\skills\architecture-decision`
  - Creates an Architecture Decision Record (ADR) documenting a significant technical decision, its context, alternatives considered, and consequences. Every major technical choice should have an ADR.

- **architecture-review** — `C:\Users\admin\.copilot\skills\architecture-review`
  - Validates completeness and consistency of the project architecture against all GDDs. Builds a traceability matrix mapping every GDD technical requirement to ADRs, identifies coverage gaps, detects cross-ADR conflicts, ve

- **art-bible** — `C:\Users\admin\.copilot\skills\art-bible`
  - Guided, section-by-section Art Bible authoring. Creates the visual identity specification that gates all asset production. Run after /brainstorm is approved and before /map-systems or any GDD authoring begins.

- **asset-audit** — `C:\Users\admin\.copilot\skills\asset-audit`
  - Audits game assets for compliance with naming conventions, file size budgets, format standards, and pipeline requirements. Identifies orphaned assets, missing references, and standard violations.

- **asset-spec** — `C:\Users\admin\.copilot\skills\asset-spec`
  - Generate per-asset visual specifications and AI generation prompts from GDDs, level docs, or character profiles. Produces structured spec files and updates the master asset manifest. Run after art bible and GDD/level des

- **balance-check** — `C:\Users\admin\.copilot\skills\balance-check`
  - Analyzes game balance data files, formulas, and configuration to identify outliers, broken progressions, degenerate strategies, and economy imbalances. Use after modifying any balance-related data or design. Use when use

- **brainstorm** — `C:\Users\admin\.copilot\skills\brainstorm`
  - Guided game concept ideation — from zero idea to a structured game concept document. Uses professional studio ideation techniques, player psychology frameworks, and structured creative exploration.

- **bug-report** — `C:\Users\admin\.copilot\skills\bug-report`
  - Creates a structured bug report from a description, or analyzes code to identify potential bugs. Ensures every bug report has full reproduction steps, severity assessment, and context.

- **bug-triage** — `C:\Users\admin\.copilot\skills\bug-triage`
  - Read all open bugs in production/qa/bugs/, re-evaluate priority vs. severity, assign to sprints, surface systemic trends, and produce a triage report. Run at sprint start or when the bug count grows enough to need re-pri

- **changelog** — `C:\Users\admin\.copilot\skills\changelog`
  - Auto-generates a changelog from git commits, sprint data, and design documents. Produces both internal and player-facing versions.

- **concept-design** — `C:\Users\admin\.copilot\skills\concept-design`
  - ゲームのコンセプトデザインを言語化するためのスキル。漠然としたアイデアを設計可能な形に変換する。使用タイミング：(1)「ゲームのコンセプトを考えたい」(2)「新しいゲームを作りたい」(3)「アイデアを整理したい」と言われた時。判断・行動・体験を中心に据えた設計言語を生成する。

- **consistency-check** — `C:\Users\admin\.copilot\skills\consistency-check`
  - Scan all GDDs against the entity registry to detect cross-document inconsistencies: same entity with different stats, same item with different values, same formula with different variables. Grep-first approach — reads re

- **content-audit** — `C:\Users\admin\.copilot\skills\content-audit`
  - Audit GDD-specified content counts against implemented content. Identifies what's planned vs built.

- **create-architecture** — `C:\Users\admin\.copilot\skills\create-architecture`
  - Guided, section-by-section authoring of the master architecture document for the game. Reads all GDDs, the systems index, existing ADRs, and the engine reference library to produce a complete architecture blueprint befor

- **create-control-manifest** — `C:\Users\admin\.copilot\skills\create-control-manifest`
  - After architecture is complete, produces a flat actionable rules sheet for programmers — what you must do, what you must never do, per system and per layer. Extracted from all Accepted ADRs, technical preferences, and en

- **create-epics** — `C:\Users\admin\.copilot\skills\create-epics`
  - Translate approved GDDs + architecture into epics — one epic per architectural module. Defines scope, governing ADRs, engine risk, and untraced requirements. Does NOT break into stories — run /create-stories [epic-slug] 

- **create-stories** — `C:\Users\admin\.copilot\skills\create-stories`
  - Break a single epic into implementable story files. Reads the epic, its GDD, governing ADRs, and control manifest. Each story embeds its GDD requirement TR-ID, ADR guidance, acceptance criteria, story type, and test evid

- **day-one-patch** — `C:\Users\admin\.copilot\skills\day-one-patch`
  - Prepare a day-one patch for a game launch. Scopes, prioritises, implements, and QA-gates a focused patch addressing known issues discovered after gold master but before or immediately after public launch. Treats the patc

- **deep-research** — `C:\Users\admin\.copilot\skills\deep-research`
  - Use when the user explicitly asks for deep research / 深度研究 / 深入调研, or when they need evidence-driven, multi-source research for a decision, report, due diligence, current-state analysis, technical comparison, recommendat

- **design-review** — `C:\Users\admin\.copilot\skills\design-review`
  - Reviews a game design document for completeness, internal consistency, implementability, and adherence to project design standards. Run this before handing a design document to programmers.

- **design-system** — `C:\Users\admin\.copilot\skills\design-system`
  - Guided, section-by-section GDD authoring for a single game system. Gathers context from existing docs, walks through each required section collaboratively, cross-references dependencies, and writes incrementally to file.

- **dev-story** — `C:\Users\admin\.copilot\skills\dev-story`
  - Read a story file and implement it. Loads the full context (story, GDD requirement, ADR guidelines, control manifest), routes to the right programmer agent for the system and engine, implements the code and test, and con

- **estimate** — `C:\Users\admin\.copilot\skills\estimate`
  - Estimates task effort by analyzing complexity, dependencies, historical velocity, and risk factors. Produces a structured estimate with confidence levels.

- **experience-design** — `C:\Users\admin\.copilot\skills\experience-design`
  - Engagement loop design, pacing frameworks, the Experience Triangle (mechanics + dynamics + aesthetics), emotion layering across a session, and evaluating whether choices feel meaningful. Use when designing the core loop,

- **fiction-writer** — `C:\Users\admin\.copilot\skills\fiction-writer`
  - Écrit un court segment fictionnel immersif pour l'Acte IV d'un épisode NEW TEMPS X. Utilise ce Skill quand tu dois créer une scène fictionnelle qui illustre les implications d'un sujet scientifique, faire ressentir plutô

- **game-design** — `C:\Users\admin\.copilot\skills\game-design`
  - 遊戲設計理論、機制設計與玩家體驗

- **game-developer** — `C:\Users\admin\.copilot\skills\game-developer`
  - Use when building game systems, implementing Unity/Unreal Engine features, or optimizing game performance. Invoke to implement ECS architecture, configure physics systems and colliders, set up multiplayer networking with

- **game-development** — `C:\Users\admin\.copilot\skills\game-development`
  - Game development with Unity, Unreal Engine, and Godot. Use when building games, implementing game mechanics, physics, AI, or working with game engines.

- **game-perf** — `C:\Users\admin\.copilot\skills\game-perf`
  - Per-frame performance and GC-pressure optimization for JS/TS game code. Use when editing game loops, update functions, render passes, physics steps, particle systems, or any code that runs every frame; when diagnosing ja

- **game-playtest-personas** — `C:\Users\admin\.copilot\skills\game-playtest-personas`
  - Simulate a game playtest on 20 diverse synthetic players (varied gender, age, experience, platform, and gaming motivation) to surface UX friction, confusion points, quit triggers, monetization reactions, and bugs before 

- **gate-check** — `C:\Users\admin\.copilot\skills\gate-check`
  - Validate readiness to advance between development phases. Produces a PASS/CONCERNS/FAIL verdict with specific blockers and required artifacts. Use when user says 'are we ready to move to X', 'can we advance to production

- **godot-assets** — `C:\Users\admin\.copilot\skills\godot-assets`
  - |

- **godot-dev** — `C:\Users\admin\.copilot\skills\godot-dev`
  - Expert knowledge of Godot Engine game development including scene creation, node management, GDScript programming, and project structure. Use when working with Godot projects, creating or modifying scenes, adding nodes, 

- **godot-effects** — `C:\Users\admin\.copilot\skills\godot-effects`
  - |

- **godot-init** — `C:\Users\admin\.copilot\skills\godot-init`
  - |

- **godot-live-edit** — `C:\Users\admin\.copilot\skills\godot-live-edit`
  - You are an expert at using the Godot AI Bridge to control a running Godot editor in real-time. This skill guides you through live editing workflows.

- **godot-ops** — `C:\Users\admin\.copilot\skills\godot-ops`
  - |

- **help** — `C:\Users\admin\.copilot\skills\help`
  - Analyzes what is done and the users query and offers advice on what to do next. Use if user says what should I do next or what do I do now or I'm stuck or I don't know what to do

- **hotfix** — `C:\Users\admin\.copilot\skills\hotfix`
  - Emergency fix workflow that bypasses normal sprint processes with a full audit trail. Creates hotfix branch, tracks approvals, and ensures the fix is backported correctly.

- **launch-checklist** — `C:\Users\admin\.copilot\skills\launch-checklist`
  - Complete launch readiness validation covering every department: code, content, store, marketing, community, infrastructure, legal, and go/no-go sign-offs.

- **localize** — `C:\Users\admin\.copilot\skills\localize`
  - Full localization pipeline: scan for hardcoded strings, extract and manage string tables, validate translations, generate translator briefings, run cultural/sensitivity review, manage VO localization, test RTL/platform r

- **manual** — `C:\Users\admin\.copilot\skills\manual`
  - Build project user manual (MkDocs) with optional Word export

- **map-systems** — `C:\Users\admin\.copilot\skills\map-systems`
  - Decompose a game concept into individual systems, map dependencies, prioritize design order, and create the systems index.

- **milestone-review** — `C:\Users\admin\.copilot\skills\milestone-review`
  - Generates a comprehensive milestone progress review including feature completeness, quality metrics, risk assessment, and go/no-go recommendation. Use at milestone checkpoints or when evaluating readiness for a milestone

- **narrative-conductor** — `C:\Users\admin\.copilot\skills\narrative-conductor`
  - Définit l'arc narratif complet et valide la cohérence narrative pour les épisodes NEW TEMPS X. Utilise ce Skill quand tu dois créer ou valider un arc narratif structuré en 7 actes, ou vérifier qu'un épisode respecte la s

- **onboard** — `C:\Users\admin\.copilot\skills\onboard`
  - Generates a contextual onboarding document for a new contributor or agent joining the project. Summarizes project state, architecture, conventions, and current priorities relevant to the specified role or area.

- **patch-notes** — `C:\Users\admin\.copilot\skills\patch-notes`
  - Generate player-facing patch notes from git history, sprint data, and internal changelogs. Translates developer language into clear, engaging player communication.

- **perf-profile** — `C:\Users\admin\.copilot\skills\perf-profile`
  - Structured performance profiling workflow. Identifies bottlenecks, measures against budgets, and generates optimization recommendations with priority rankings.

- **player-ux** — `C:\Users\admin\.copilot\skills\player-ux`
  - Cognitive load management for players: perception/attention/memory framework, Gestalt principles for game UI, signal-noise discipline on the HUD, onboarding ramp design, and tooltip/affordance patterns. Use when designin

- **playtest-report** — `C:\Users\admin\.copilot\skills\playtest-report`
  - Generates a structured playtest report template or analyzes existing playtest notes into a structured format. Use this to standardize playtest feedback collection and analysis.

- **project-stage-detect** — `C:\Users\admin\.copilot\skills\project-stage-detect`
  - Automatically analyze project state, detect stage, identify gaps, and recommend next steps based on existing artifacts. Use when user asks 'where are we in development', 'what stage are we in', 'full project audit'.

- **propagate-design-change** — `C:\Users\admin\.copilot\skills\propagate-design-change`
  - When a GDD is revised, scans all ADRs and the traceability index to identify which architectural decisions are now potentially stale. Produces a change impact report and guides the user through resolution.

- **prototype** — `C:\Users\admin\.copilot\skills\prototype`
  - Concept prototype — validate the core idea is worth designing before writing GDDs. Run right after /brainstorm and /setup-engine. Routes to HTML, Engine, or Paper path based on game type. Produces a throwaway build and a

- **psych-motivation** — `C:\Users\admin\.copilot\skills\psych-motivation`
  - Motivation and engagement validation for game development. Invoked by game-psychologist agent at validation checkpoints. Applies Self-Determination Theory, Flow Theory, Expectancy-Value, Attribution Theory, and Operant C

- **qa-plan** — `C:\Users\admin\.copilot\skills\qa-plan`
  - Generate a QA test plan for a sprint or feature. Reads GDDs and story files, classifies stories by test type (Logic/Integration/Visual/UI), and produces a structured test plan covering automated tests required, manual te

- **quick-design** — `C:\Users\admin\.copilot\skills\quick-design`
  - Lightweight design spec for small changes — tuning adjustments, minor mechanics, balance tweaks. Skips full GDD authoring when a system GDD already exists or the change is too small to warrant one. Produces a Quick Desig

- **regression-suite** — `C:\Users\admin\.copilot\skills\regression-suite`
  - Map test coverage to GDD critical paths, identify fixed bugs without regression tests, flag coverage drift from new features, and maintain tests/regression-suite.md. Run after implementing a bug fix or before a release g

- **release-checklist** — `C:\Users\admin\.copilot\skills\release-checklist`
  - Generates a comprehensive pre-release validation checklist covering build verification, certification requirements, store metadata, and launch readiness.

- **retrospective** — `C:\Users\admin\.copilot\skills\retrospective`
  - Generates a sprint or milestone retrospective by analyzing completed work, velocity, blockers, and patterns. Produces actionable insights for the next iteration.

- **reverse-document** — `C:\Users\admin\.copilot\skills\reverse-document`
  - Generate design or architecture documents from existing implementation. Works backwards from code/prototypes to create missing planning docs.

- **review-all-gdds** — `C:\Users\admin\.copilot\skills\review-all-gdds`
  - Holistic cross-GDD consistency and game design review. Reads all system GDDs simultaneously and checks for contradictions between them, stale references, ownership conflicts, formula incompatibilities, and game design th

- **scope-check** — `C:\Users\admin\.copilot\skills\scope-check`
  - Analyze a feature or sprint for scope creep by comparing current scope against the original plan. Flags additions, quantifies bloat, and recommends cuts. Use when user says 'any scope creep', 'scope review', 'are we stay

- **security-audit** — `C:\Users\admin\.copilot\skills\security-audit`
  - Audit the game for security vulnerabilities: save tampering, cheat vectors, network exploits, data exposure, and input validation gaps. Produces a prioritised security report with remediation guidance. Run before any pub

- **setup-engine** — `C:\Users\admin\.copilot\skills\setup-engine`
  - Configure the project's game engine and version. Pins the engine in CLAUDE.md, detects knowledge gaps, and populates engine reference docs via WebSearch when the version is beyond the LLM's training data.

- **skill-improve** — `C:\Users\admin\.copilot\skills\skill-improve`
  - Improve a skill using a test-fix-retest loop. Runs static checks, proposes targeted fixes, rewrites the skill, re-tests, and keeps or reverts based on score change.

- **skill-installer** — `C:\Users\admin\.copilot\skills\skill-installer`
  - Instala, valida, registra e verifica novas skills no ecossistema. 10 checks de seguranca, copia, registro no orchestrator e verificacao pos-instalacao.

- **skill-test** — `C:\Users\admin\.copilot\skills\skill-test`
  - Validate skill files for structural compliance and behavioral correctness. Three modes: static (linter), spec (behavioral), audit (coverage report).

- **smoke-check** — `C:\Users\admin\.copilot\skills\smoke-check`
  - Run the critical path smoke test gate before QA hand-off. Executes the automated test suite, verifies core functionality, and produces a PASS/FAIL report. Run after a sprint's stories are implemented and before manual QA

- **soak-test** — `C:\Users\admin\.copilot\skills\soak-test`
  - Generate a soak test protocol for extended play sessions. Defines what to observe, measure, and log during long play sessions to surface slow leaks, fatigue effects, and edge cases that only appear after sustained play. 

- **sprint-plan** — `C:\Users\admin\.copilot\skills\sprint-plan`
  - Generates a new sprint plan or updates an existing one based on the current milestone, completed work, and available capacity. Pulls context from production documents and design backlogs.

- **sprint-status** — `C:\Users\admin\.copilot\skills\sprint-status`
  - Fast sprint status check. Reads the current sprint plan, scans story files for status, and produces a concise progress snapshot with burndown assessment and emerging risks. Run at any time during a sprint for quick situa

- **start** — `C:\Users\admin\.copilot\skills\start`
  - First-time onboarding — asks where you are, then guides you to the right workflow. No assumptions.

- **story-done** — `C:\Users\admin\.copilot\skills\story-done`
  - End-of-story completion review. Reads the story file, verifies each acceptance criterion against the implementation, checks for GDD/ADR deviations, prompts code review, updates story status to Complete, and surfaces the 

- **story-readiness** — `C:\Users\admin\.copilot\skills\story-readiness`
  - Validate that a story file is implementation-ready. Checks for embedded GDD requirements, ADR references, engine notes, clear acceptance criteria, and no open design questions. Produces READY / NEEDS WORK / BLOCKED verdi

- **team-audio** — `C:\Users\admin\.copilot\skills\team-audio`
  - Orchestrate audio team: audio-director + sound-designer + technical-artist + gameplay-programmer for full audio pipeline from direction to implementation.

- **team-combat** — `C:\Users\admin\.copilot\skills\team-combat`
  - Orchestrate the combat team: coordinates game-designer, gameplay-programmer, ai-programmer, technical-artist, sound-designer, and qa-tester to design, implement, and validate a combat feature end-to-end.

- **team-level** — `C:\Users\admin\.copilot\skills\team-level`
  - Orchestrate level design team: level-designer + narrative-director + world-builder + art-director + systems-designer + qa-tester for complete area/level creation.

- **team-live-ops** — `C:\Users\admin\.copilot\skills\team-live-ops`
  - Orchestrate the live-ops team for post-launch content planning: coordinates live-ops-designer, economy-designer, analytics-engineer, community-manager, writer, and narrative-director to design and plan a season, event, o

- **team-narrative** — `C:\Users\admin\.copilot\skills\team-narrative`
  - Orchestrate the narrative team: coordinates narrative-director, writer, world-builder, and level-designer to create cohesive story content, world lore, and narrative-driven level design.

- **team-polish** — `C:\Users\admin\.copilot\skills\team-polish`
  - Orchestrate the polish team: coordinates performance-analyst, technical-artist, sound-designer, and qa-tester to optimize, polish, and harden a feature or area for release quality.

- **team-qa** — `C:\Users\admin\.copilot\skills\team-qa`
  - Orchestrate the QA team through a full testing cycle. Coordinates qa-lead (strategy + test plan) and qa-tester (test case writing + bug reporting) to produce a complete QA package for a sprint or feature. Covers: test pl

- **team-release** — `C:\Users\admin\.copilot\skills\team-release`
  - Orchestrate the release team: coordinates release-manager, qa-lead, devops-engineer, and producer to execute a release from candidate to deployment.

- **team-ui** — `C:\Users\admin\.copilot\skills\team-ui`
  - Orchestrate the UI team through the full UX pipeline: from UX spec authoring through visual design, implementation, review, and polish. Integrates with /ux-design, /ux-review, and studio UX templates.

- **team-ux-improve** — `C:\Users\admin\.copilot\skills\team-ux-improve`
  - Unified team skill for UX improvement. Systematically discovers and fixes UI/UX interaction issues including unresponsive buttons, missing feedback, and state refresh problems. Uses team-worker agent architecture with ro

- **tech-debt** — `C:\Users\admin\.copilot\skills\tech-debt`
  - Track, categorize, and prioritize technical debt across the codebase. Scans for debt indicators, maintains a debt register, and recommends repayment scheduling.

- **test-evidence-review** — `C:\Users\admin\.copilot\skills\test-evidence-review`
  - Quality review of test files and manual evidence documents. Goes beyond existence checks — evaluates assertion coverage, edge case handling, naming conventions, and evidence completeness. Produces ADEQUATE/INCOMPLETE/MIS

- **test-flakiness** — `C:\Users\admin\.copilot\skills\test-flakiness`
  - Detect non-deterministic (flaky) tests by reading CI run logs or test result history. Aggregates pass rates per test, identifies intermittent failures, recommends quarantine or fix, and maintains a flaky test registry. B

- **test-helpers** — `C:\Users\admin\.copilot\skills\test-helpers`
  - Generate engine-specific test helper libraries for the project's test suite. Reads existing test patterns and produces tests/helpers/ with assertion utilities, factory functions, and mock objects tailored to the project'

- **test-setup** — `C:\Users\admin\.copilot\skills\test-setup`
  - Scaffold the test framework and CI/CD pipeline for the project's engine. Creates the tests/ directory structure, engine-specific test runner configuration, and GitHub Actions workflow. Run once during Technical Setup pha

- **ui-ux-pro-max** — `C:\Users\admin\.copilot\skills\ui-ux-pro-max`
  - Design intelligence for UI/UX generation and critique; use for layouts, typography, color palettes, tokens, and UX best practices. 50 styles, 21 palettes, 50 font pairings, 20 charts, 9 stacks (React, Next.js, Vue, Svelt

- **ux-design** — `C:\Users\admin\.copilot\skills\ux-design`
  - Guided, section-by-section UX spec authoring for a screen, flow, or HUD. Reads game concept, player journey, and relevant GDDs to provide context-aware design guidance. Produces ux-spec.md (per screen/flow) or hud-design

- **ux-design-standards** — `C:\Users\admin\.copilot\skills\ux-design-standards`
  - UX design principles for agent-console. Use when designing features, evaluating acceptance criteria, or reviewing user-facing interactions in a multi-agent management UI.

- **ux-review** — `C:\Users\admin\.copilot\skills\ux-review`
  - Validates a UX spec, HUD design, or interaction pattern library for completeness, accessibility compliance, GDD alignment, and implementation readiness. Produces APPROVED / NEEDS REVISION / MAJOR REVISION NEEDED verdict 

- **vertical-slice** — `C:\Users\admin\.copilot\skills\vertical-slice`
  - Pre-Production validation — build a production-quality end-to-end build to confirm the full game loop is achievable before committing to Production. Run after GDDs, architecture, and UX specs are complete. Produces a PRO

- **2d-essentials** — `C:\Users\admin\.claude\skills\2d-essentials`
  - Use when working with 2D-specific systems — TileMaps, parallax scrolling, 2D lights and shadows, canvas layers, particles 2D, custom drawing, and 2D meshes in Godot 4.3+

- **academic-cv-builder** — `C:\Users\admin\.claude\skills\academic-cv-builder`
  - Format CVs for academic positions with publications, grants, and teaching

- **adhd-design-expert** — `C:\Users\admin\.claude\skills\adhd-design-expert`
  - Designs digital experiences for ADHD brains using neuroscience research and UX principles. Expert in reducing cognitive load, time blindness solutions, dopamine-driven engagement, and compassionate

- **admin-dashboard** — `C:\Users\admin\.claude\skills\admin-dashboard`
  - Extend and modify the admin dashboard, developer portal, and operations console. Use when adding new admin tabs, metrics, monitoring features, or internal tools. Activates for dashboard development,

- **adopt** — `C:\Users\admin\.claude\skills\adopt`
  - Brownfield onboarding — audits existing project artifacts for template format compliance (not just existence), classifies gaps by impact, and produces a numbered migration plan. Run this when joining an in-progress proje

- **agency-brand-scoping** — `C:\Users\admin\.claude\skills\agency-brand-scoping`
  - Five brand direction variations for pitch discovery.

- **agency-client-handoff** — `C:\Users\admin\.claude\skills\agency-client-handoff`
  - Export a white-label client deliverable as a zip.

- **agency-multi-brand-pack** — `C:\Users\admin\.claude\skills\agency-multi-brand-pack`
  - Per-client asset templates scoped by workspace.

- **android-ci-cd-release-playstore** — `C:\Users\admin\.claude\skills\android-ci-cd-release-playstore`
  - Automate Android CI, versioning, signing boundaries, release channels, and Play-ready delivery workflows.

- **android-clean-architecture** — `C:\Users\admin\.claude\skills\android-clean-architecture`
  - Clean Architecture patterns for Android and Kotlin Multiplatform projects — module structure, dependency rules, UseCases, Repositories, and data layer patterns.

- **android-cli** — `C:\Users\admin\.claude\skills\android-cli`
  - Provides instructions for installing and using the `android` CLI. The `android` command-line tool is a critical tool for Android development and helps you create new Android projects, run Android apps on devices, manage 

- **android-kotlin** — `C:\Users\admin\.claude\skills\android-kotlin`
  - Android Kotlin development with Coroutines, Jetpack Compose, Hilt, and MockK testing

- **android-native-dev** — `C:\Users\admin\.claude\skills\android-native-dev`
  - Android native application development and UI design guide. Covers Material Design 3, Kotlin/Compose development, project configuration, accessibility, and build troubleshooting. Read this before Android native applicati

- **android-playstore-scan** — `C:\Users\admin\.claude\skills\android-playstore-scan`
  - Scan Android project and generate Play Console setup checklist (analysis only, no file modifications)

- **android-playstore-setup** — `C:\Users\admin\.claude\skills\android-playstore-setup`
  - Complete Play Store setup - orchestrates scanning, privacy policy, version management, Fastlane, and workflows (Internal track only)

- **applicant-screening** — `C:\Users\admin\.claude\skills\applicant-screening`
  - Screen job applications against requirements and score candidates

- **application-form-filler** — `C:\Users\admin\.claude\skills\application-form-filler`
  - Fill out job application form fields with context-aware, tailored answers drawn from the candidate's CV and the job description

- **apply** — `C:\Users\admin\.claude\skills\apply`
  - Fill out a job application on Greenhouse, Lever, or Workday

- **architecture-decision** — `C:\Users\admin\.claude\skills\architecture-decision`
  - Creates an Architecture Decision Record (ADR) documenting a significant technical decision, its context, alternatives considered, and consequences. Every major technical choice should have an ADR.

- **architecture-review** — `C:\Users\admin\.claude\skills\architecture-review`
  - Validates completeness and consistency of the project architecture against all GDDs. Builds a traceability matrix mapping every GDD technical requirement to ADRs, identifies coverage gaps, detects cross-ADR conflicts, ve

- **art-bible** — `C:\Users\admin\.claude\skills\art-bible`
  - Guided, section-by-section Art Bible authoring. Creates the visual identity specification that gates all asset production. Run after /brainstorm is approved and before /map-systems or any GDD authoring begins.

- **asset-audit** — `C:\Users\admin\.claude\skills\asset-audit`
  - Audits game assets for compliance with naming conventions, file size budgets, format standards, and pipeline requirements. Identifies orphaned assets, missing references, and standard violations.

- **asset-spec** — `C:\Users\admin\.claude\skills\asset-spec`
  - Generate per-asset visual specifications and AI generation prompts from GDDs, level docs, or character profiles. Produces structured spec files and updates the master asset manifest. Run after art bible and GDD/level des

- **balance-check** — `C:\Users\admin\.claude\skills\balance-check`
  - Analyzes game balance data files, formulas, and configuration to identify outliers, broken progressions, degenerate strategies, and economy imbalances. Use after modifying any balance-related data or design. Use when use

- **brainstorm** — `C:\Users\admin\.claude\skills\brainstorm`
  - Guided game concept ideation — from zero idea to a structured game concept document. Uses professional studio ideation techniques, player psychology frameworks, and structured creative exploration.

- **bug-report** — `C:\Users\admin\.claude\skills\bug-report`
  - Creates a structured bug report from a description, or analyzes code to identify potential bugs. Ensures every bug report has full reproduction steps, severity assessment, and context.

- **bug-triage** — `C:\Users\admin\.claude\skills\bug-triage`
  - Read all open bugs in production/qa/bugs/, re-evaluate priority vs. severity, assign to sprints, surface systemic trends, and produce a triage report. Run at sprint start or when the bug count grows enough to need re-pri

- **capability-evolver** — `C:\Users\admin\.claude\skills\capability-evolver`
  - A self-evolution engine for AI agents. Analyzes runtime history to identify improvements and applies protocol-constrained evolution. Communicates with EvoMap Hub via local Proxy mailbox.

- **career-biographer** — `C:\Users\admin\.claude\skills\career-biographer`
  - AI-powered career biographer that conducts empathetic interviews, extracts structured career narratives, and transforms professional stories into portfolios, CVs, and personal brand assets.

- **career-changer-translator** — `C:\Users\admin\.claude\skills\career-changer-translator`
  - Translate skills from one industry to another, identify transferable skills

- **changelog** — `C:\Users\admin\.claude\skills\changelog`
  - Auto-generates a changelog from git commits, sprint data, and design documents. Produces both internal and player-facing versions.

- **clinical-diagnostic-reasoning** — `C:\Users\admin\.claude\skills\clinical-diagnostic-reasoning`
  - Identify and counteract cognitive biases in medical decision-making through systematic error analysis and contextual algorithm application. For diagnostic reasoning, treatment decisions, and

- **cold-email-writer** — `C:\Users\admin\.claude\skills\cold-email-writer`
  - Write personalized cold outreach emails to hiring managers and founders — specific, human, not a pitch deck

- **concept-design** — `C:\Users\admin\.claude\skills\concept-design`
  - ゲームのコンセプトデザインを言語化するためのスキル。漠然としたアイデアを設計可能な形に変換する。使用タイミング：(1)「ゲームのコンセプトを考えたい」(2)「新しいゲームを作りたい」(3)「アイデアを整理したい」と言われた時。判断・行動・体験を中心に据えた設計言語を生成する。

- **consistency-check** — `C:\Users\admin\.claude\skills\consistency-check`
  - Scan all GDDs against the entity registry to detect cross-document inconsistencies: same entity with different stats, same item with different values, same formula with different variables. Grep-first approach — reads re

- **content-audit** — `C:\Users\admin\.claude\skills\content-audit`
  - Audit GDD-specified content counts against implemented content. Identifies what's planned vs built.

- **contract-review** — `C:\Users\admin\.claude\skills\contract-review`
  - Analyze contracts for risks, check completeness, and provide actionable recommendations. Supports employment contracts, NDAs, service agreements, and more.

- **cover-letter** — `C:\Users\admin\.claude\skills\cover-letter`
  - Write a tailored cover letter for a specific job posting

- **cover-letter-generator** — `C:\Users\admin\.claude\skills\cover-letter-generator`
  - Create personalized, compelling cover letters from resume and job description

- **create-architecture** — `C:\Users\admin\.claude\skills\create-architecture`
  - Guided, section-by-section authoring of the master architecture document for the game. Reads all GDDs, the systems index, existing ADRs, and the engine reference library to produce a complete architecture blueprint befor

- **create-control-manifest** — `C:\Users\admin\.claude\skills\create-control-manifest`
  - After architecture is complete, produces a flat actionable rules sheet for programmers — what you must do, what you must never do, per system and per layer. Extracted from all Accepted ADRs, technical preferences, and en

- **create-epics** — `C:\Users\admin\.claude\skills\create-epics`
  - Translate approved GDDs + architecture into epics — one epic per architectural module. Defines scope, governing ADRs, engine risk, and untraced requirements. Does NOT break into stories — run /create-stories [epic-slug] 

- **create-stories** — `C:\Users\admin\.claude\skills\create-stories`
  - Break a single epic into implementable story files. Reads the epic, its GDD, governing ADRs, and control manifest. Each story embeds its GDD requirement TR-ID, ADR guidance, acceptance criteria, story type, and test evid

- **creating-godot-procedural-audio** — `C:\Users\admin\.claude\skills\creating-godot-procedural-audio`
  - Designs and implements procedural audio for Godot games. Use when creating runtime SFX with Godot built-in audio APIs, mapping game events to timbre, or avoiding external audio assets.

- **creative-portfolio-resume** — `C:\Users\admin\.claude\skills\creative-portfolio-resume`
  - Balance visual design with ATS compatibility for creative roles

- **critiquing-own-response** — `C:\Users\admin\.claude\skills\critiquing-own-response`
  - Performs structured, ruthless critical self-review of the agent's own immediately preceding response. Use ONLY when the user explicitly requests critical-thinking, self-critique, criticalthink, or asks the agent to chall

- **custom-gpt-builder** — `C:\Users\admin\.claude\skills\custom-gpt-builder`
  - >-

- **cv-builder** — `C:\Users\admin\.claude\skills\cv-builder`
  - >

- **cv-creator** — `C:\Users\admin\.claude\skills\cv-creator`
  - Professional CV and resume builder transforming career narratives into ATS-optimized, multi-format resumes. Integrates with career-biographer for data and competitive-cartographer for positioning.

- **cv-resume** — `C:\Users\admin\.claude\skills\cv-resume`
  - Generate professional, ATS-optimized CVs and resumes as polished HTML files. Use this skill whenever the user asks to create, write, build, update, or improve a CV, resume, curriculum vitae, or job application document —

- **cv-reviewer** — `C:\Users\admin\.claude\skills\cv-reviewer`
  - Reviews and critiques a CV/resume against proven best practices, providing a structured checklist with severity-tiered feedback and actionable suggestions for each item. Use this skill whenever a user asks to review, cri

- **day-one-patch** — `C:\Users\admin\.claude\skills\day-one-patch`
  - Prepare a day-one patch for a game launch. Scopes, prioritises, implements, and QA-gates a focused patch addressing known issues discovered after gold master but before or immediately after public launch. Treats the patc

- **deep-research** — `C:\Users\admin\.claude\skills\deep-research`
  - Use when the user explicitly asks for deep research / 深度研究 / 深入调研, or when they need evidence-driven, multi-source research for a decision, report, due diligence, current-state analysis, technical comparison, recommendat

- **design-review** — `C:\Users\admin\.claude\skills\design-review`
  - Reviews a game design document for completeness, internal consistency, implementability, and adherence to project design standards. Run this before handing a design document to programmers.

- **design-system** — `C:\Users\admin\.claude\skills\design-system`
  - Guided, section-by-section GDD authoring for a single game system. Gathers context from existing docs, walks through each required section collaboratively, cross-references dependencies, and writes incrementally to file.

- **designing-mini-games** — `C:\Users\admin\.claude\skills\designing-mini-games`
  - Designs compact, playable game rules and controls. Use when defining a new mini-game concept, converting creative constraints into mechanics, checking state-variable necessity, or preventing idle/mashing from becoming op

- **designing-one-button-games** — `C:\Users\admin\.claude\skills\designing-one-button-games`
  - Designs original one-button mini-games using tap, hold, and release controls, with emphasis on novelty, risk/reward, and a short difficulty curve. Use when planning mechanics, scoring, game-over conditions, and difficult

- **dev-app-assets** — `C:\Users\admin\.claude\skills\dev-app-assets`
  - Generate icons, empty states, onboarding for apps.

- **dev-avatar-service** — `C:\Users\admin\.claude\skills\dev-avatar-service`
  - Deterministic default-avatar generator per user.

- **dev-screenshot-beautifier** — `C:\Users\admin\.claude\skills\dev-screenshot-beautifier`
  - Polish raw screenshots into LP-ready heroes.

- **dev-story** — `C:\Users\admin\.claude\skills\dev-story`
  - Read a story file and implement it. Loads the full context (story, GDD requirement, ADR guidelines, control manifest), routes to the right programmer agent for the system and engine, implements the code and test, and con

- **developing-with-crisp-game-lib** — `C:\Users\admin\.claude\skills\developing-with-crisp-game-lib`
  - Creates or repairs browser mini-games specifically using crisp-game-lib. Use only when the user explicitly asks for crisp-game-lib or the existing project already uses it; skip for Godot, Unity, Phaser, canvas-only, or u

- **directing-game-visuals** — `C:\Users\admin\.claude\skills\directing-game-visuals`
  - Directs readable, coherent game visuals. Use when defining visual hierarchy, palette roles, screen composition, event feedback, or reducing generic AI-looking game art without relying on HUD text.

- **doc-coauthoring** — `C:\Users\admin\.claude\skills\doc-coauthoring`
  - Guide users through a structured workflow for co-authoring documentation. Use when user wants to write documentation, proposals, technical specs, decision docs, or similar structured content. This workflow helps users ef

- **doc-parser** — `C:\Users\admin\.claude\skills\doc-parser`
  - >

- **doc-pipeline** — `C:\Users\admin\.claude\skills\doc-pipeline`
  - Chain document operations into reusable pipelines

- **document-generation-pdf** — `C:\Users\admin\.claude\skills\document-generation-pdf`
  - Generate, fill, and assemble PDF documents at scale. Handles legal forms, contracts, invoices, certificates. Supports form filling (pdf-lib), template rendering (Puppeteer, LaTeX), digital

- **docx** — `C:\Users\admin\.claude\skills\docx`
  - Comprehensive document creation, editing, and analysis with support for tracked changes, comments, formatting preservation, and text extraction. When Claude needs to work with professional documents (.docx files) for: (1

- **docx-manipulation** — `C:\Users\admin\.claude\skills\docx-manipulation`
  - Create, edit, and manipulate Word documents programmatically using python-docx

- **drone-cv-expert** — `C:\Users\admin\.claude\skills\drone-cv-expert`
  - Expert in drone systems, computer vision, and autonomous navigation. Specializes in flight control, SLAM, object detection, sensor fusion, and path planning. Activate on "drone", "UAV", "SLAM",

- **email-composer** — `C:\Users\admin\.claude\skills\email-composer`
  - Draft professional emails for various contexts including business, technical, and customer communication. Use when the user needs help writing emails or composing professional messages.

- **emotional-narrative** — `C:\Users\admin\.claude\skills\emotional-narrative`
  - Use when animation needs to convey feeling, tell a story, or connect emotionally—character moments, dramatic beats, or any motion that should make the audience care.

- **enterprise-brand-governor** — `C:\Users\admin\.claude\skills\enterprise-brand-governor`
  - Gate every generation through a brand policy file.

- **enterprise-pinned-registry** — `C:\Users\admin\.claude\skills\enterprise-pinned-registry`
  - Pin exact model versions for reproducible output.

- **enterprise-press-batch** — `C:\Users\admin\.claude\skills\enterprise-press-batch`
  - Press photos into wire, web, print, social packs.

- **estimate** — `C:\Users\admin\.claude\skills\estimate`
  - Estimates task effort by analyzing complexity, dependencies, historical velocity, and risk factors. Produces a structured estimate with confidence levels.

- **evaluating-gameplay-balance** — `C:\Users\admin\.claude\skills\evaluating-gameplay-balance`
  - Evaluates and improves gameplay balance from telemetry in any engine. Use when comparing monotonous vs exploratory play, diagnosing death/spawn/scoring/input issues, or proposing structural balance fixes instead of numer

- **excel-automation** — `C:\Users\admin\.claude\skills\excel-automation`
  - >

- **executive-resume-writer** — `C:\Users\admin\.claude\skills\executive-resume-writer`
  - Create C-suite and VP level resumes emphasizing strategic leadership

- **experience-design** — `C:\Users\admin\.claude\skills\experience-design`
  - Engagement loop design, pacing frameworks, the Experience Triangle (mechanics + dynamics + aesthetics), emotion layering across a session, and evaluating whether choices feel meaningful. Use when designing the core loop,

- **extracting-agent-skills** — `C:\Users\admin\.claude\skills\extracting-agent-skills`
  - Distills reusable agent skills (procedures, validation loops, debugging methods, tool-use patterns, decision rules) from completed, abandoned, paused, or failed projects. Use when closing/archiving a project, reducing si

- **eyes** — `C:\Users\admin\.claude\skills\eyes`
  - WHEN users express dissatisfaction with visual appearance or behavior; use Playwright MCP to capture screenshots and collaborate on UI fixes with a structured feedback loop.

- **fiction-writer** — `C:\Users\admin\.claude\skills\fiction-writer`
  - Écrit un court segment fictionnel immersif pour l'Acte IV d'un épisode NEW TEMPS X. Utilise ce Skill quand tu dois créer une scène fictionnelle qui illustre les implications d'un sujet scientifique, faire ressentir plutô

- **financial-goal-planner** — `C:\Users\admin\.claude\skills\financial-goal-planner`
  - Create timelines for house down payment, retirement, college fund. Monthly savings targets, investment strategies, milestone tracking.

- **find-skills** — `C:\Users\admin\.claude\skills\find-skills`
  - Helps users discover, search, and install skills from the skills.sh registry using the npx skills CLI. Use this skill when users ask to find skills, browse the skill registry, install a skill, or search for skills by nam

- **fresh-eyes** — `C:\Users\admin\.claude\skills\fresh-eyes`
  - Re-reads code you just wrote with fresh perspective to catch bugs, errors, and issues. Use after completing a feature, fixing a bug, or any code changes. Triggers on "review my code", "fresh eyes", "check for bugs", "did

- **game-architecture** — `C:\Users\admin\.claude\skills\game-architecture`
  - Game architecture patterns and best practices for browser games. Use when designing game systems, planning architecture, structuring a game project, or making architectural decisions about game code.

- **game-assets** — `C:\Users\admin\.claude\skills\game-assets`
  - Game asset engineer that creates pixel art sprites, animated characters, and visual entities for browser games. Use when a game needs better character art, enemy sprites, item visuals, or any upgrade from basic geometric

- **game-balancing** — `C:\Users\admin\.claude\skills\game-balancing`
  - >

- **game-design** — `C:\Users\admin\.claude\skills\game-design`
  - 遊戲設計理論、機制設計與玩家體驗

- **game-developer** — `C:\Users\admin\.claude\skills\game-developer`
  - Use when building game systems, implementing Unity/Unreal Engine features, or optimizing game performance. Invoke to implement ECS architecture, configure physics systems and colliders, set up multiplayer networking with

- **game-development** — `C:\Users\admin\.claude\skills\game-development`
  - Game development with Unity, Unreal Engine, and Godot. Use when building games, implementing game mechanics, physics, AI, or working with game engines.

- **game-perf** — `C:\Users\admin\.claude\skills\game-perf`
  - Per-frame performance and GC-pressure optimization for JS/TS game code. Use when editing game loops, update functions, render passes, physics steps, particle systems, or any code that runs every frame; when diagnosing ja

- **game-playtest-personas** — `C:\Users\admin\.claude\skills\game-playtest-personas`
  - Simulate a game playtest on 20 diverse synthetic players (varied gender, age, experience, platform, and gaming motivation) to surface UX friction, confusion points, quit triggers, monetization reactions, and bugs before 

- **gate-check** — `C:\Users\admin\.claude\skills\gate-check`
  - Validate readiness to advance between development phases. Produces a PASS/CONCERNS/FAIL verdict with specific blockers and required artifacts. Use when user says 'are we ready to move to X', 'can we advance to production

- **gen-ai-explainer** — `C:\Users\admin\.claude\skills\gen-ai-explainer`
  - Use when the user wants a short animated explainer video. Trigger phrases include "animated explainer", "make an explainer", "explainer video about X", "30-second video about Y", "90-second video explaining Z", "how X wo

- **gen-ai-persona-creation** — `C:\Users\admin\.claude\skills\gen-ai-persona-creation`
  - Create AI influencer or branded character personas.

- **gen-ai-use** — `C:\Users\admin\.claude\skills\gen-ai-use`
  - Generate AI images, videos, audio via Picsart gen-ai CLI.

- **generating-dot-assets** — `C:\Users\admin\.claude\skills\generating-dot-assets`
  - Generates transparent pixel-art object assets from a subject and target pixel size using a host-provided image-generation tool, chroma-key removal, pixelization, exact canvas fitting, and PNG validation. Use for game obj

- **godot-2d-animation** — `C:\Users\admin\.claude\skills\godot-2d-animation`
  - Expert patterns for 2D animation in Godot using AnimatedSprite2D and skeletal cutout rigs. Use when implementing sprite frame animations, procedural animation (squash/stretch), cutout bone hierarchies, or frame-perfect t

- **godot-2d-physics** — `C:\Users\admin\.claude\skills\godot-2d-physics`
  - Expert patterns for Godot 2D physics including collision layers/masks, Area2D triggers, raycasting, and PhysicsDirectSpaceState2D queries. Use when implementing collision detection, trigger zones, line-of-sight systems, 

- **godot-3d-lighting** — `C:\Users\admin\.claude\skills\godot-3d-lighting`
  - Expert patterns for Godot 3D lighting including DirectionalLight3D shadow cascades, OmniLight3D attenuation, SpotLight3D projectors, VoxelGI vs SDFGI, and LightmapGI baking. Use when implementing realistic 3D lighting, s

- **godot-ability-system** — `C:\Users\admin\.claude\skills\godot-ability-system`
  - Expert patterns for RPG/action ability systems including cooldown strategies, combo systems, ability chaining, skill trees with prerequisites, upgrade paths, and resource management. Use when implementing unlockable abil

- **godot-adapt-2d-to-3d** — `C:\Users\admin\.claude\skills\godot-adapt-2d-to-3d`
  - Expert patterns for migrating 2D games to 3D including node type conversions, camera systems (third-person, first-person, orbit), physics layer migration, sprite-to-model art pipeline, and control scheme adaptations. Use

- **godot-animation-player** — `C:\Users\admin\.claude\skills\godot-animation-player`
  - Expert patterns for AnimationPlayer including track types (Value, Method, Audio, Bezier), root motion extraction, animation callbacks, procedural animation generation, call mode optimization, and RESET tracks. Use for ti

- **godot-animation-tree-mastery** — `C:\Users\admin\.claude\skills\godot-animation-tree-mastery`
  - Expert patterns for AnimationTree including StateMachine transitions, BlendSpace2D for directional movement, BlendTree for layered animations, root motion, transition conditions, advance expressions, and state machine su

- **godot-asset-generator** — `C:\Users\admin\.claude\skills\godot-asset-generator`
  - Generate game assets using AI image generation APIs (DALL-E, Replicate, fal.ai) and prepare them for Godot. Covers the full art pipeline from concept art and style guides to final sprites, sprite sheets, and import confi

- **godot-assets** — `C:\Users\admin\.claude\skills\godot-assets`
  - |

- **godot-auditor** — `C:\Users\admin\.claude\skills\godot-auditor`
  - Godot Expert Auditor: Aurelius. Exhaustive never-list enforcement and architectural slap-down for Godot 4.6 projects.

- **godot-autoload-architecture** — `C:\Users\admin\.claude\skills\godot-autoload-architecture`
  - Expert patterns for Godot AutoLoad (singleton) architecture including global state management, scene transitions, signal-based communication, dependency injection, autoload initialization order, and anti-patterns to avoi

- **godot-best-practices** — `C:\Users\admin\.claude\skills\godot-best-practices`
  - Guide AI agents through Godot 4.x GDScript coding best practices including scene organization, signals, resources, state machines, and performance optimization. This skill should be used when generating GDScript code, cr

- **godot-brainstorming** — `C:\Users\admin\.claude\skills\godot-brainstorming`
  - Use when designing a new Godot feature or system — guides scene tree planning, node type selection, and architectural decisions

- **godot-builder** — `C:\Users\admin\.claude\skills\godot-builder`
  - Expert-level toolkit for modular Godot 4.x CLI automation and headless build orchestration.

- **godot-camera-systems** — `C:\Users\admin\.claude\skills\godot-camera-systems`
  - Expert patterns for 2D/3D camera control including smooth following (lerp, position_smoothing), camera shake (trauma system), screen shake with frequency parameters, deadzone/drag for platformers, look-ahead prediction, 

- **godot-characterbody-2d** — `C:\Users\admin\.claude\skills\godot-characterbody-2d`
  - Expert patterns for CharacterBody2D including platformer movement (coyote time, jump buffering, variable jump height), top-down movement (8-way, tank controls), collision handling, one-way platforms, and state machines. 

- **godot-code-review** — `C:\Users\admin\.claude\skills\godot-code-review`
  - Use when reviewing GDScript or C# Godot code — checklist of best practices, common anti-patterns, and Godot-specific pitfalls

- **godot-composition** — `C:\Users\admin\.claude\skills\godot-composition`
  - Expert architectural standards for building scalable Godot GAMES (RPGs, Platformers, Shooters) using the Composition pattern (Entity-Component). Use when designing player controllers, NPCs, enemies, weapons, or complex g

- **godot-debugging** — `C:\Users\admin\.claude\skills\godot-debugging`
  - Expert knowledge of Godot debugging, error interpretation, common bugs, and troubleshooting techniques. Use when helping fix Godot errors, crashes, or unexpected behavior.

- **godot-dev** — `C:\Users\admin\.claude\skills\godot-dev`
  - Expert knowledge of Godot Engine game development including scene creation, node management, GDScript programming, and project structure. Use when working with Godot projects, creating or modifying scenes, adding nodes, 

- **godot-dialogue-system** — `C:\Users\admin\.claude\skills\godot-dialogue-system`
  - Expert patterns for branching dialogue systems including dialogue graphs (Resource-based), character portraits, player choices, conditional dialogue (flags/quests), typewriter effects, localization support, and voice act

- **godot-effects** — `C:\Users\admin\.claude\skills\godot-effects`
  - |

- **godot-game-loop-collection** — `C:\Users\admin\.claude\skills\godot-game-loop-collection`
  - Use when implementing collection quests, scavenger hunts, or "find all X" objectives.

- **godot-gdscript-mastery** — `C:\Users\admin\.claude\skills\godot-gdscript-mastery`
  - Expert GDScript best practices including static typing (var x: int, func returns void), signal architecture (signal up call down), unique node access (%NodeName, @onready), script structure (extends, class_name, signals,

- **godot-gdscript-patterns** — `C:\Users\admin\.claude\skills\godot-gdscript-patterns`
  - Master Godot 4 GDScript patterns including signals, scenes, state machines, and optimization. Use when building Godot games, implementing game systems, or learning GDScript best practices.

- **godot-genre-action-rpg** — `C:\Users\admin\.claude\skills\godot-genre-action-rpg`
  - Comprehensive blueprint for Action RPGs including real-time combat (hitbox/hurtbox, stat-based damage), character progression (RPG stats, leveling, skill trees), loot systems (procedural item generation, affixes, rarity 

- **godot-genre-idle-clicker** — `C:\Users\admin\.claude\skills\godot-genre-idle-clicker`
  - Expert blueprint for idle/clicker games including big number handling (mantissa + exponent system), exponential growth curves (cost_growth_factor 1.15x), generator systems (auto-producers), offline progress calculation, 

- **godot-genre-platformer** — `C:\Users\admin\.claude\skills\godot-genre-platformer`
  - Expert blueprint for platformer games including precision movement (coyote time, jump buffering, variable jump height), game feel polish (squash/stretch, particle trails, camera shake), level design principles (difficult

- **godot-genre-simulation** — `C:\Users\admin\.claude\skills\godot-genre-simulation`
  - Expert blueprint for simulation and tycoon games (SimCity, RollerCoaster Tycoon, Factorio, Two Point Hospital) covering economy management, time progression, interconnected systems, NPC simulation, and feedback loops. Us

- **godot-genre-visual-novel** — `C:\Users\admin\.claude\skills\godot-genre-visual-novel`
  - Expert blueprint for visual novels (Doki Doki Literature Club, Phoenix Wright, Steins;Gate) focusing on branching narratives, dialogue systems, choice consequences, rollback mechanics, and persistent flags. Use when buil

- **godot-init** — `C:\Users\admin\.claude\skills\godot-init`
  - |

- **godot-input-handling** — `C:\Users\admin\.claude\skills\godot-input-handling`
  - Expert patterns for input handling covering InputMap actions, InputEvent processing, controller support, rebinding, deadzones, and input buffering. Use when setting up player controls, implementing input systems, or addi

- **godot-inventory-system** — `C:\Users\admin\.claude\skills\godot-inventory-system`
  - Expert blueprint for inventory systems (Diablo, Resident Evil, Minecraft) covering slot-based containers, stacking logic, weight limits, equipment systems, and drag-drop UI. Use when building RPG inventories, survival it

- **godot-live-edit** — `C:\Users\admin\.claude\skills\godot-live-edit`
  - You are an expert at using the Godot AI Bridge to control a running Godot editor in real-time. This skill guides you through live editing workflows.

- **godot-master** — `C:\Users\admin\.claude\skills\godot-master`
  - Consolidated expert library for professional Godot 4.x game and application development. Orchestrates 94 specialized blueprints through architectural workflows, anti-pattern catalogs, performance budgets, and Server API 

- **godot-mechanic-secrets** — `C:\Users\admin\.claude\skills\godot-mechanic-secrets`
  - Use when implementing cheat codes, hidden interactions, or unlockable content based on player input/behavior.

- **godot-ops** — `C:\Users\admin\.claude\skills\godot-ops`
  - |

- **godot-optimization** — `C:\Users\admin\.claude\skills\godot-optimization`
  - Expert knowledge of Godot performance optimization, profiling, bottleneck identification, and optimization techniques. Use when helping improve game performance or analyzing performance issues.

- **godot-particles** — `C:\Users\admin\.claude\skills\godot-particles`
  - Expert blueprint for GPU particle systems (explosions, magic effects, weather, trails) using GPUParticles2D/3D, ParticleProcessMaterial, gradients, sub-emitters, and custom shaders. Use when creating VFX, environmental e

- **godot-performance-optimization** — `C:\Users\admin\.claude\skills\godot-performance-optimization`
  - Expert blueprint for performance profiling and optimization (frame drops, memory leaks, draw calls) using Godot Profiler, object pooling, visibility culling, and bottleneck identification. Use when diagnosing lag, optimi

- **godot-platform-desktop** — `C:\Users\admin\.claude\skills\godot-platform-desktop`
  - Expert blueprint for desktop platforms (Windows/Linux/macOS) covering keyboard/mouse controls, settings menus, window management (fullscreen, resolution), keybind remapping, and Steam integration. Use when targeting PC p

- **godot-platform-mobile** — `C:\Users\admin\.claude\skills\godot-platform-mobile`
  - Expert blueprint for mobile platforms (Android/iOS) covering touch controls, virtual joysticks, responsive UI, safe areas (notches), battery optimization, and app store guidelines. Use when targeting mobile releases or i

- **godot-platform-web** — `C:\Users\admin\.claude\skills\godot-platform-web`
  - Expert blueprint for web/browser platforms (HTML5 export) covering WebGL/WebGPU rendering, custom loading screens, JavaScriptBridge integration, LocalStorage saves, and size optimization. Use when exporting to web or imp

- **godot-quest-system** — `C:\Users\admin\.claude\skills\godot-quest-system`
  - Expert blueprint for quest  tracking systems (objectives, progress, rewards, branching chains) using Resource-based quests, signal-driven updates, and AutoLoad managers. Use when implementing RPG quests or mission system

- **godot-resource-data-patterns** — `C:\Users\admin\.claude\skills\godot-resource-data-patterns`
  - Expert blueprint for data-oriented design using Resource/RefCounted classes (item databases, character stats, reusable data structures). Covers typed arrays, serialization, nested resources, and resource caching. Use whe

- **godot-rpg-stats** — `C:\Users\admin\.claude\skills\godot-rpg-stats`
  - Expert blueprint for RPG stat systems (attributes, leveling, modifiers, damage formulas) using Resource-based stats, stackable modifiers, and derived stat calculations. Use when implementing character progression OR equi

- **godot-scene-management** — `C:\Users\admin\.claude\skills\godot-scene-management`
  - Expert blueprint for scene loading, transitions, async (background) loading, instance management, and caching. Covers fade transitions, loading screens, dynamic spawning, and scene persistence. Use when implementing leve

- **godot-shaders-basics** — `C:\Users\admin\.claude\skills\godot-shaders-basics`
  - Expert blueprint for shader programming (visual effects, post-processing, material customization) using Godot's GLSL-like shader language. Covers canvas_item (2D), spatial (3D), uniforms, built-in variables, and performa

- **godot-turn-system** — `C:\Users\admin\.claude\skills\godot-turn-system`
  - Expert blueprint for turn-based combat with turn order, action points, phase management, and timeline systems for strategy/RPG games. Covers speed-based initiative, interrupts, and simultaneous turns. Use when implementi

- **godot-tweening** — `C:\Users\admin\.claude\skills\godot-tweening`
  - Expert blueprint for programmatic animation using Tween for smooth property transitions, UI effects, camera movements, and juice. Covers easing functions, parallel tweens, chaining, and lifecycle management. Use when imp

- **godot-ui** — `C:\Users\admin\.claude\skills\godot-ui`
  - Expert knowledge of Godot's UI system including Control nodes, themes, styling, responsive layouts, and common UI patterns for menus, HUDs, inventories, and dialogue systems. Use when working with Godot UI/menu creation 

- **godot-ui-containers** — `C:\Users\admin\.claude\skills\godot-ui-containers`
  - Expert blueprint for responsive UI layouts using Container nodes (HBoxContainer, VBoxContainer, GridContainer, MarginContainer, ScrollContainer). Covers size flags, anchors, split containers, and dynamic layouts. Use whe

- **godot-ui-rich-text** — `C:\Users\admin\.claude\skills\godot-ui-rich-text`
  - Expert blueprint for RichTextLabel with BBCode formatting (bold, italic, colors, images, clickable links) and custom effects. Covers meta tags, RichTextEffect shaders, and dynamic content. Use when implementing dialogue 

- **godot-ui-theming** — `C:\Users\admin\.claude\skills\godot-ui-theming`
  - Expert blueprint for UI themes using Theme resources, StyleBoxes, custom fonts, and theme overrides for consistent visual styling. Covers StyleBoxFlat/Texture, theme inheritance, dynamic theme switching, and font variati

- **gplay-cli-usage** — `C:\Users\admin\.claude\skills\gplay-cli-usage`
  - Guidance for using the Google Play Console CLI in this repo (flags, output formats, pagination, auth, and discovery). Use when asked to run or design gplay commands or interact with Google Play Console via the CLI.

- **gplay-gradle-build** — `C:\Users\admin\.claude\skills\gplay-gradle-build`
  - Build, sign, and package Android apps with Gradle before uploading to Google Play. Use when asked to create an APK or AAB, configure signing, or set up build pipelines.

- **gplay-iap-setup** — `C:\Users\admin\.claude\skills\gplay-iap-setup`
  - In-app products, subscriptions, base plans, and offers setup for Google Play monetization, including bulk-localizing subscription display names, descriptions, and benefits across all locales. Use when configuring in-app 

- **gplay-metadata-sync** — `C:\Users\admin\.claude\skills\gplay-metadata-sync`
  - Metadata and localization sync (including Fastlane format) for Google Play Store listings. Use when updating app descriptions, screenshots, or managing multi-locale metadata.

- **gplay-migrate-fastlane** — `C:\Users\admin\.claude\skills\gplay-migrate-fastlane`
  - Migration from Fastlane supply to gplay CLI using the gplay migrate fastlane command. Use when asked to convert a Fastlane-based Play Store workflow to gplay, or to import existing Fastlane metadata directories.

- **gplay-ppp-pricing** — `C:\Users\admin\.claude\skills\gplay-ppp-pricing`
  - Set region-specific pricing for subscriptions and in-app purchases using purchasing power parity (PPP). Use when adjusting prices by country or implementing localized pricing strategies on Google Play.

- **gplay-purchase-verification** — `C:\Users\admin\.claude\skills\gplay-purchase-verification`
  - Server-side purchase verification for in-app products and subscriptions using Google Play Developer API. Use when implementing receipt validation in your backend.

- **gplay-release-flow** — `C:\Users\admin\.claude\skills\gplay-release-flow`
  - End-to-end release workflows for Google Play tracks (internal, beta, production) using gplay release, promote, and rollout commands. Use when asked to upload a build, distribute to testers, or release to production.

- **gplay-reports-download** — `C:\Users\admin\.claude\skills\gplay-reports-download`
  - Financial and statistics report listing and downloading from Google Play Console via GCS. Use when asked to view, list, or download financial earnings, sales, payouts, or app statistics (installs, ratings, crashes).

- **gplay-review-management** — `C:\Users\admin\.claude\skills\gplay-review-management`
  - Review monitoring, filtering, and automated responses for Google Play. Use when managing user reviews and feedback.

- **gplay-rollout-management** — `C:\Users\admin\.claude\skills\gplay-rollout-management`
  - Staged rollout orchestration and monitoring for Google Play releases. Use when implementing gradual release strategies.

- **gplay-screenshot-automation** — `C:\Users\admin\.claude\skills\gplay-screenshot-automation`
  - Manage, validate, and upload Google Play listing screenshots and graphics with the gplay CLI. Use when organizing screenshots by locale and device type and pushing them to a Play listing via gplay images upload, sync imp

- **gplay-submission-checks** — `C:\Users\admin\.claude\skills\gplay-submission-checks`
  - Pre-submission validation for Google Play releases covering metadata, screenshots, bundle integrity, data safety, and policy compliance. Use when preparing a release to avoid rejections and catch issues before submitting

- **gplay-testers-orchestration** — `C:\Users\admin\.claude\skills\gplay-testers-orchestration`
  - Manage testers for Google Play testing tracks (internal, closed alpha/beta, custom) using edit sessions. Use when assigning testers, creating closed tracks, or promoting builds between tracks.

- **gplay-user-management** — `C:\Users\admin\.claude\skills\gplay-user-management`
  - User and grant management for Google Play Console via gplay users and gplay grants commands. Use when asked to manage developer account users, account-wide permissions, or per-app access grants.

- **gplay-vitals-monitoring** — `C:\Users\admin\.claude\skills\gplay-vitals-monitoring`
  - Monitor Android app stability and performance from the Play Developer Reporting API via gplay vitals. Use to query crash/ANR rates, detect release regressions with anomaly detection, filter error issues/reports with AIP-

- **gpt-image-2** — `C:\Users\admin\.claude\skills\gpt-image-2`
  - >

- **graphic-design** — `C:\Users\admin\.claude\skills\graphic-design`
  - Professional graphic design principles for digital and print media. Use when creating visual designs, choosing color palettes, typography, layouts, or providing design feedback.

- **help** — `C:\Users\admin\.claude\skills\help`
  - Analyzes what is done and the users query and offers advice on what to do next. Use if user says what should I do next or what do I do now or I'm stuck or I don't know what to do

- **herald-events** — `C:\Users\admin\.claude\skills\herald-events`
  - Format eventów narracyjnych HERALD — JSON schema, typy efektów, zasady pisania. Aktywuj gdy tworzysz lub edytujesz pliki w data/events/.

- **herald-gdscript** — `C:\Users\admin\.claude\skills\herald-gdscript`
  - Wzorce GDScript dla projektu HERALD — Godot 4, izometryczne RPG. Aktywuj gdy piszesz skrypty .gd dla HERALD.

- **herald-narrative** — `C:\Users\admin\.claude\skills\herald-narrative`
  - Kontekst narracyjny gry HERALD — postacie, fabula, zakończenia. Aktywuj gdy piszesz dialogi, eventy, tekst UI, albo pracujesz z narracją.

- **hiring-manager-deep-dive** — `C:\Users\admin\.claude\skills\hiring-manager-deep-dive`
  - Prepares for hiring manager rounds at Staff+ (L6+) level — scope of impact, influence without authority, ambiguity navigation, mentorship, strategic thinking. Use when practicing HM rounds

- **hiring-scorecard** — `C:\Users\admin\.claude\skills\hiring-scorecard`
  - Creates structured hiring scorecards for any role. Takes job title, requirements, and team context. Generates comprehensive scorecard with weighted scoring rubric, interview questions per competency, evaluation matrix, r

- **hotfix** — `C:\Users\admin\.claude\skills\hotfix`
  - Emergency fix workflow that bypasses normal sprint processes with a full audit trail. Creates hotfix branch, tracks approvals, and ensures the fix is backported correctly.

- **hr-automation** — `C:\Users\admin\.claude\skills\hr-automation`
  - HR workflow automation - recruiting, onboarding, employee management, and offboarding processes

- **hr-network-analyst** — `C:\Users\admin\.claude\skills\hr-network-analyst`
  - Professional network graph analyst identifying Gladwellian superconnectors, mavens, and influence brokers using betweenness centrality, structural holes theory, and multi-source network reconstruction.

- **implementing-gameplay-invariants** — `C:\Users\admin\.claude\skills\implementing-gameplay-invariants`
  - Translates game design prose into engine-neutral implementation invariants and validation checks. Use when implementing or reviewing game mechanics where idle, hold-only, mashing, spam, safe waiting, or repeated scoring 

- **interview-loop-strategist** — `C:\Users\admin\.claude\skills\interview-loop-strategist`
  - Orchestrates end-to-end interview preparation for senior ML/AI engineers targeting Anthropic and peer companies. Use for prep timeline generation, story coherence across rounds, mock scheduling,

- **interview-prep-generator** — `C:\Users\admin\.claude\skills\interview-prep-generator`
  - Generate STAR stories, practice questions, and talking points from resume

- **interview-simulator** — `C:\Users\admin\.claude\skills\interview-simulator`
  - Designs and orchestrates a realistic interview simulation platform with voice AI, whiteboard evaluation, gaze-tracking proctoring, and mobile spaced repetition. Use for building mock interview

- **job-application-optimizer** — `C:\Users\admin\.claude\skills\job-application-optimizer`
  - Optimize job applications by tailoring resumes to job postings, generating customized cover letters, and preparing role-specific interview questions. Analyzes job descriptions to highlight relevant skills and experience.

- **job-description** — `C:\Users\admin\.claude\skills\job-description`
  - >

- **job-description-analyzer** — `C:\Users\admin\.claude\skills\job-description-analyzer`
  - Analyze job postings, calculate match scores, identify gaps, and create application strategy

- **job-search** — `C:\Users\admin\.claude\skills\job-search`
  - Search for jobs matching my resume and preferences

- **job-search-strategist** — `C:\Users\admin\.claude\skills\job-search-strategist`
  - Comprehensive job search strategy skill for analyzing job postings, discovering non-obvious insights, conducting conversational skills-matching interviews, identifying skill development needs and creating creative, perso

- **jobsearch-telegram** — `C:\Users\admin\.claude\skills\jobsearch-telegram`
  - Poll Telegram for job search messages — apply to jobs, search for roles, check status, all via chat

- **launch-checklist** — `C:\Users\admin\.claude\skills\launch-checklist`
  - Complete launch readiness validation covering every department: code, content, store, marketing, community, infrastructure, legal, and go/no-go sign-offs.

- **lead-research** — `C:\Users\admin\.claude\skills\lead-research`
  - Research company and contact information for sales outreach

- **linkedin-automation** — `C:\Users\admin\.claude\skills\linkedin-automation`
  - Automate LinkedIn marketing, lead generation, content publishing, and professional networking

- **linkedin-post-optimizer** — `C:\Users\admin\.claude\skills\linkedin-post-optimizer`
  - Professional narrative style with line breaks, hashtag strategy, and hooks in first 2 lines to avoid truncation

- **linkedin-profile-optimizer** — `C:\Users\admin\.claude\skills\linkedin-profile-optimizer`
  - Optimize LinkedIn profile for searchability, recruiter visibility, and engagement

- **localize** — `C:\Users\admin\.claude\skills\localize`
  - Full localization pipeline: scan for hardcoded strings, extract and manage string tables, validate translations, generate translator briefings, run cultural/sensitivity review, manage VO localization, test RTL/platform r

- **manual** — `C:\Users\admin\.claude\skills\manual`
  - Build project user manual (MkDocs) with optional Word export

- **map-systems** — `C:\Users\admin\.claude\skills\map-systems`
  - Decompose a game concept into individual systems, map dependencies, prioritize design order, and create the systems index.

- **marketer-ad-variant-factory** — `C:\Users\admin\.claude\skills\marketer-ad-variant-factory`
  - Fan out 50+ ad variants from one hero image.

- **marketer-localize-campaign** — `C:\Users\admin\.claude\skills\marketer-localize-campaign`
  - Localize a campaign across N markets.

- **maximizing-game-feel** — `C:\Users\admin\.claude\skills\maximizing-game-feel`
  - Improves the tactile satisfaction (\"game feel\") of action games whose visuals are functional but flat. Use when a game runs correctly but feels lifeless; applies to players, enemies, obstacles, projectiles, and items.

- **milestone-review** — `C:\Users\admin\.claude\skills\milestone-review`
  - Generates a comprehensive milestone progress review including feature completeness, quality metrics, risk assessment, and go/no-go recommendation. Use at milestone checkpoints or when evaluating readiness for a milestone

- **mobile-android-design** — `C:\Users\admin\.claude\skills\mobile-android-design`
  - Master Material Design 3 and Jetpack Compose patterns for building native Android apps. Use when designing Android interfaces, implementing Compose UI, or following Google's Material Design guidelines.

- **multi-channel-bundle** — `C:\Users\admin\.claude\skills\multi-channel-bundle`
  - Ship a coordinated multi-format asset bundle for any push.

- **narrative-conductor** — `C:\Users\admin\.claude\skills\narrative-conductor`
  - Définit l'arc narratif complet et valide la cohérence narrative pour les épisodes NEW TEMPS X. Utilise ce Skill quand tu dois créer ou valider un arc narratif structuré en 7 actes, ou vérifier qu'un épisode respecte la s

- **network-scan** — `C:\Users\admin\.claude\skills\network-scan`
  - Scan your LinkedIn contacts' companies for matching job openings

- **offer-comparison-analyzer** — `C:\Users\admin\.claude\skills\offer-comparison-analyzer`
  - Compare multiple job offers side-by-side with total compensation analysis

- **offer-letter** — `C:\Users\admin\.claude\skills\offer-letter`
  - Create formal employment offer letters with compensation and terms

- **onboard** — `C:\Users\admin\.claude\skills\onboard`
  - Generates a contextual onboarding document for a new contributor or agent joining the project. Summarizes project state, architecture, conventions, and current priorities relevant to the specified role or area.

- **patch-notes** — `C:\Users\admin\.claude\skills\patch-notes`
  - Generate player-facing patch notes from git history, sprint data, and internal changelogs. Translates developer language into clear, engaging player communication.

- **pdf** — `C:\Users\admin\.claude\skills\pdf`
  - Comprehensive PDF manipulation toolkit for extracting text and tables, creating new PDFs, merging/splitting documents, and handling forms. When Claude needs to fill in a PDF form or programmatically process, generate, or

- **pdf-to-docx** — `C:\Users\admin\.claude\skills\pdf-to-docx`
  - Convert PDF files to editable Word documents using pdf2docx

- **perf-profile** — `C:\Users\admin\.claude\skills\perf-profile`
  - Structured performance profiling workflow. Identifies bottlenecks, measures against budgets, and generates optimization recommendations with priority rankings.

- **picsart-api** — `C:\Users\admin\.claude\skills\picsart-api`
  - Generate and edit media via Picsart MCP API tools.

- **pixijs-scene-graphics** — `C:\Users\admin\.claude\skills\pixijs-scene-graphics`
  - Use this skill when drawing vector shapes and paths in PixiJS v8. Covers the Graphics API: shape-then-fill methods (rect/circle/ellipse/poly/roundRect/star/regularPoly/roundPoly/roundShape/filletRect/chamferRect), path m

- **player-ux** — `C:\Users\admin\.claude\skills\player-ux`
  - Cognitive load management for players: perception/attention/memory framework, Gestalt principles for game UI, signal-noise discipline on the HUD, onboarding ramp design, and tooltip/affordance patterns. Use when designin

- **playstore-submission-content** — `C:\Users\admin\.claude\skills\playstore-submission-content`
  - Generate ready-to-paste Google Play Store text content for Android app submissions. Analyzes project context and produces all required text fields with Play Store character rules enforced.

- **playtest-report** — `C:\Users\admin\.claude\skills\playtest-report`
  - Generates a structured playtest report template or analyzes existing playtest notes into a structured format. Use this to standardize playtest feedback collection and analysis.

- **portfolio-analyzer** — `C:\Users\admin\.claude\skills\portfolio-analyzer`
  - Review investment portfolios for risk, diversification, fees. Asset allocation recommendations, tax-loss harvesting, rebalancing.

- **portfolio-case-study-writer** — `C:\Users\admin\.claude\skills\portfolio-case-study-writer`
  - Transform resume bullets into detailed portfolio case studies

- **pptx** — `C:\Users\admin\.claude\skills\pptx`
  - Presentation creation, editing, and analysis. When Claude needs to work with presentations (.pptx files) for: (1) Creating new presentations, (2) Modifying or editing content, (3) Working with layouts, (4) Adding comment

- **product-photo-studio** — `C:\Users\admin\.claude\skills\product-photo-studio`
  - Transform product photos via Picsart gen-ai — six modes.

- **project-management-guru-adhd** — `C:\Users\admin\.claude\skills\project-management-guru-adhd`
  - Expert project manager for ADHD engineers managing multiple concurrent projects. Specializes in hyperfocus management, context-switching minimization, and parakeet-style gentle reminders. Activate

- **project-stage-detect** — `C:\Users\admin\.claude\skills\project-stage-detect`
  - Automatically analyze project state, detect stage, identify gaps, and recommend next steps based on existing artifacts. Use when user asks 'where are we in development', 'what stage are we in', 'full project audit'.

- **propagate-design-change** — `C:\Users\admin\.claude\skills\propagate-design-change`
  - When a GDD is revised, scans all ADRs and the traceability index to identify which architectural decisions are now potentially stale. Produces a change impact report and guides the user through resolution.

- **prosumer-headshot-studio** — `C:\Users\admin\.claude\skills\prosumer-headshot-studio`
  - Selfie to four polished headshots for any use.

- **prototype** — `C:\Users\admin\.claude\skills\prototype`
  - Concept prototype — validate the core idea is worth designing before writing GDDs. Run right after /brainstorm and /setup-engine. Routes to HTML, Engine, or Paper path based on game type. Produces a throwaway build and a

- **psych-motivation** — `C:\Users\admin\.claude\skills\psych-motivation`
  - Motivation and engagement validation for game development. Invoked by game-psychologist agent at validation checkpoints. Applies Self-Determination Theory, Flow Theory, Expectancy-Value, Attribution Theory, and Operant C

- **qa-plan** — `C:\Users\admin\.claude\skills\qa-plan`
  - Generate a QA test plan for a sprint or feature. Reads GDDs and story files, classifies stories by test type (Logic/Integration/Visual/UI), and produces a structured test plan covering automated tests required, manual te

- **quick-design** — `C:\Users\admin\.claude\skills\quick-design`
  - Lightweight design spec for small changes — tuning adjustments, minor mechanics, balance tweaks. Skips full GDD authoring when a system GDD already exists or the change is too small to warrant one. Produces a Quick Desig

- **raise-negotiation-prep** — `C:\Users\admin\.claude\skills\raise-negotiation-prep`
  - Market salary research, accomplishment quantification, negotiation scripts, total compensation analysis, timing strategy.

- **reference-list-builder** — `C:\Users\admin\.claude\skills\reference-list-builder`
  - Format professional references properly and prepare reference materials

- **regression-suite** — `C:\Users\admin\.claude\skills\regression-suite`
  - Map test coverage to GDD critical paths, identify fixed bugs without regression tests, flag coverage drift from new features, and maintain tests/regression-suite.md. Run after implementing a bug fix or before a release g

- **release-checklist** — `C:\Users\admin\.claude\skills\release-checklist`
  - Generates a comprehensive pre-release validation checklist covering build verification, certification requirements, store metadata, and launch readiness.

- **report-generator** — `C:\Users\admin\.claude\skills\report-generator`
  - Generate professional data reports with charts, tables, and visualizations

- **resume-ats-optimizer** — `C:\Users\admin\.claude\skills\resume-ats-optimizer`
  - Optimize resumes for Applicant Tracking Systems, check ATS compatibility, and analyze keyword match

- **resume-builder** — `C:\Users\admin\.claude\skills\resume-builder`
  - Comprehensive resume creation, review and optimization with support for multiple formats, ATS optimization, industry-specific guidance and career stage customization. Use this skill when users request help writing, creat

- **resume-bullet-writer** — `C:\Users\admin\.claude\skills\resume-bullet-writer`
  - Transform weak resume bullets into achievement-focused statements with metrics and impact

- **resume-formatter** — `C:\Users\admin\.claude\skills\resume-formatter`
  - Ensure ATS-friendly formatting and create clean scannable layouts

- **resume-quantifier** — `C:\Users\admin\.claude\skills\resume-quantifier`
  - Find opportunities to add metrics and estimate numbers when exact data unavailable

- **resume-section-builder** — `C:\Users\admin\.claude\skills\resume-section-builder`
  - Create targeted resume sections optimized for different experience levels and roles

- **resume-tailor** — `C:\Users\admin\.claude\skills\resume-tailor`
  - >

- **resume-version-manager** — `C:\Users\admin\.claude\skills\resume-version-manager`
  - Track different resume versions, maintain master resume, manage tailored versions

- **resume-writing** — `C:\Users\admin\.claude\skills\resume-writing`
  - Write effective resume bullets and content. Use when writing, rewriting, or improving resume bullets, sections, or any resume text. Covers bullet composition, length, word choice, tailoring, keyword placement, and gender

- **resumx** — `C:\Users\admin\.claude\skills\resumx`
  - Work with Resumx, a Markdown-to-PDF resume renderer. Use when creating, editing, converting, building, styling, or tailoring resumes. Covers syntax, CLI, style options, icons, tags, views, variables, multi-language, page

- **retrospective** — `C:\Users\admin\.claude\skills\retrospective`
  - Generates a sprint or milestone retrospective by analyzing completed work, velocity, blockers, and patterns. Produces actionable insights for the next iteration.

- **reverse-document** — `C:\Users\admin\.claude\skills\reverse-document`
  - Generate design or architecture documents from existing implementation. Works backwards from code/prototypes to create missing planning docs.

- **review-all-gdds** — `C:\Users\admin\.claude\skills\review-all-gdds`
  - Holistic cross-GDD consistency and game design review. Reads all system GDDs simultaneously and checks for contradictions between them, stale references, ownership conflicts, formula incompatibilities, and game design th

- **review-resume** — `C:\Users\admin\.claude\skills\review-resume`
  - Comprehensive PM resume review and tailoring against 10 best practices including XYZ+S formula, keyword optimization, job-specific tailoring, and structure. Use when reviewing a PM resume, preparing for job applications,

- **salary-negotiation-prep** — `C:\Users\admin\.claude\skills\salary-negotiation-prep`
  - Research market rates, build negotiation strategy, and create counter-offer scripts

- **scope-check** — `C:\Users\admin\.claude\skills\scope-check`
  - Analyze a feature or sprint for scope creep by comparing current scope against the original plan. Flags additions, quantifies bloat, and recommends cuts. Use when user says 'any scope creep', 'scope review', 'are we stay

- **security-audit** — `C:\Users\admin\.claude\skills\security-audit`
  - Audit the game for security vulnerabilities: save tampering, cheat vectors, network exploits, data exposure, and input validation gaps. Produces a prioritised security report with remediation guidance. Run before any pub

- **setup** — `C:\Users\admin\.claude\skills\setup`
  - One-time onboarding - upload resume, set preferences, and do a work history interview

- **setup-engine** — `C:\Users\admin\.claude\skills\setup-engine`
  - Configure the project's game engine and version. Pins the engine in CLAUDE.md, detects knowledge gaps, and populates engine reference docs via WebSearch when the version is beyond the LLM's training data.

- **skill-creator** — `C:\Users\admin\.claude\skills\skill-creator`
  - Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill pe

- **skill-improve** — `C:\Users\admin\.claude\skills\skill-improve`
  - Improve a skill using a test-fix-retest loop. Runs static checks, proposes targeted fixes, rewrites the skill, re-tests, and keeps or reverts based on score change.

- **skill-installer** — `C:\Users\admin\.claude\skills\skill-installer`
  - Instala, valida, registra e verifica novas skills no ecossistema. 10 checks de seguranca, copia, registro no orchestrator e verificacao pos-instalacao.

- **skill-test** — `C:\Users\admin\.claude\skills\skill-test`
  - Validate skill files for structural compliance and behavioral correctness. Three modes: static (linter), spec (behavioral), audit (coverage report).

- **smithery-ai-cli** — `C:\Users\admin\.claude\skills\smithery-ai-cli`
  - Find, connect, and use MCP tools and skills via the Smithery CLI. Use when the user searches for new tools or skills, wants to discover integrations, connect to an MCP, install a skill, or wants to interact with an exter

- **smoke-check** — `C:\Users\admin\.claude\skills\smoke-check`
  - Run the critical path smoke test gate before QA hand-off. Executes the automated test suite, verifies core functionality, and produces a PASS/FAIL report. Run after a sprint's stories are implemented and before manual QA

- **soak-test** — `C:\Users\admin\.claude\skills\soak-test`
  - Generate a soak test protocol for extended play sessions. Defines what to observe, measure, and log during long play sessions to surface slow leaks, fatigue effects, and edge cases that only appear after sustained play. 

- **social-publisher** — `C:\Users\admin\.claude\skills\social-publisher`
  - Multi-platform social media publishing automation - schedule, post, and track content across TikTok, Instagram, YouTube, LinkedIn, and more

- **sprint-plan** — `C:\Users\admin\.claude\skills\sprint-plan`
  - Generates a new sprint plan or updates an existing one based on the current milestone, completed work, and available capacity. Pulls context from production documents and design backlogs.

- **sprint-status** — `C:\Users\admin\.claude\skills\sprint-status`
  - Fast sprint status check. Reads the current sprint plan, scans story files for status, and produces a concise progress snapshot with burndown assessment and emerging risks. Run at any time during a sprint for quick situa

- **start** — `C:\Users\admin\.claude\skills\start`
  - First-time onboarding — asks where you are, then guides you to the right workflow. No assumptions.

- **story-done** — `C:\Users\admin\.claude\skills\story-done`
  - End-of-story completion review. Reads the story file, verifies each acceptance criterion against the implementation, checks for GDD/ADR deviations, prompts code review, updates story status to Complete, and surfaces the 

- **story-readiness** — `C:\Users\admin\.claude\skills\story-readiness`
  - Validate that a story file is implementation-ready. Checks for embedded GDD requirements, ADR references, engine notes, clear acceptance criteria, and no open design questions. Produces READY / NEEDS WORK / BLOCKED verdi

- **story-review** — `C:\Users\admin\.claude\skills\story-review`
  - |

- **story-setup** — `C:\Users\admin\.claude\skills\story-setup`
  - |

- **storytelling-expert** — `C:\Users\admin\.claude\skills\storytelling-expert`
  - This skill should be used when the user needs to transform ideas, presentations, speeches, or data into persuasive stories using elite storytelling frameworks.

- **styling-web-game-typography** — `C:\Users\admin\.claude\skills\styling-web-game-typography`
  - Implements readable, licensed typography for distributed games (web export, downloadable, packaged). Use when defining theme-based text roles, adopting fonts, handling font licenses for redistribution, or checking HUD re

- **tailor-resume** — `C:\Users\admin\.claude\skills\tailor-resume`
  - Tailor your resume for a specific job posting

- **tailored-resume-generator** — `C:\Users\admin\.claude\skills\tailored-resume-generator`
  - Analyzes job descriptions and generates tailored resumes that highlight relevant experience, skills and achievements to maximize interview chances

- **team-audio** — `C:\Users\admin\.claude\skills\team-audio`
  - Orchestrate audio team: audio-director + sound-designer + technical-artist + gameplay-programmer for full audio pipeline from direction to implementation.

- **team-combat** — `C:\Users\admin\.claude\skills\team-combat`
  - Orchestrate the combat team: coordinates game-designer, gameplay-programmer, ai-programmer, technical-artist, sound-designer, and qa-tester to design, implement, and validate a combat feature end-to-end.

- **team-level** — `C:\Users\admin\.claude\skills\team-level`
  - Orchestrate level design team: level-designer + narrative-director + world-builder + art-director + systems-designer + qa-tester for complete area/level creation.

- **team-live-ops** — `C:\Users\admin\.claude\skills\team-live-ops`
  - Orchestrate the live-ops team for post-launch content planning: coordinates live-ops-designer, economy-designer, analytics-engineer, community-manager, writer, and narrative-director to design and plan a season, event, o

- **team-narrative** — `C:\Users\admin\.claude\skills\team-narrative`
  - Orchestrate the narrative team: coordinates narrative-director, writer, world-builder, and level-designer to create cohesive story content, world lore, and narrative-driven level design.

- **team-polish** — `C:\Users\admin\.claude\skills\team-polish`
  - Orchestrate the polish team: coordinates performance-analyst, technical-artist, sound-designer, and qa-tester to optimize, polish, and harden a feature or area for release quality.

- **team-qa** — `C:\Users\admin\.claude\skills\team-qa`
  - Orchestrate the QA team through a full testing cycle. Coordinates qa-lead (strategy + test plan) and qa-tester (test case writing + bug reporting) to produce a complete QA package for a sprint or feature. Covers: test pl

- **team-release** — `C:\Users\admin\.claude\skills\team-release`
  - Orchestrate the release team: coordinates release-manager, qa-lead, devops-engineer, and producer to execute a release from candidate to deployment.

- **team-ui** — `C:\Users\admin\.claude\skills\team-ui`
  - Orchestrate the UI team through the full UX pipeline: from UX spec authoring through visual design, implementation, review, and polish. Integrates with /ux-design, /ux-review, and studio UX templates.

- **team-ux-improve** — `C:\Users\admin\.claude\skills\team-ux-improve`
  - Unified team skill for UX improvement. Systematically discovers and fixes UI/UX interaction issues including unresponsive buttons, missing feedback, and state refresh problems. Uses team-worker agent architecture with ro

- **tech-debt** — `C:\Users\admin\.claude\skills\tech-debt`
  - Track, categorize, and prioritize technical debt across the codebase. Scans for debt indicators, maintains a debt register, and recommends repayment scheduling.

- **tech-presentation-interview** — `C:\Users\admin\.claude\skills\tech-presentation-interview`
  - Prepares for "reverse system design" rounds where you present YOUR past technical work. Use for project selection, narrative arc structuring, whiteboard diagrams, depth calibration, and hostile

- **tech-resume-optimizer** — `C:\Users\admin\.claude\skills\tech-resume-optimizer`
  - Optimize resumes for software engineering, PM, and technical roles

- **technical-writer** — `C:\Users\admin\.claude\skills\technical-writer`
  - Expert technical documentation specialist for developer docs, API references, and runbooks. Activate on: documentation, docs, README, API reference, technical writing, user guide, runbook,

- **test-evidence-review** — `C:\Users\admin\.claude\skills\test-evidence-review`
  - Quality review of test files and manual evidence documents. Goes beyond existence checks — evaluates assertion coverage, edge case handling, naming conventions, and evidence completeness. Produces ADEQUATE/INCOMPLETE/MIS

- **test-flakiness** — `C:\Users\admin\.claude\skills\test-flakiness`
  - Detect non-deterministic (flaky) tests by reading CI run logs or test result history. Aggregates pass rates per test, identifies intermittent failures, recommends quarantine or fix, and maintains a flaky test registry. B

- **test-helpers** — `C:\Users\admin\.claude\skills\test-helpers`
  - Generate engine-specific test helper libraries for the project's test suite. Reads existing test patterns and produces tests/helpers/ with assertion utilities, factory functions, and mock objects tailored to the project'

- **test-setup** — `C:\Users\admin\.claude\skills\test-setup`
  - Scaffold the test framework and CI/CD pipeline for the project's engine. Creates the tests/ directory structure, engine-specific test runner configuration, and GitHub Actions workflow. Run once during Technical Setup pha

- **text-to-visual** — `C:\Users\admin\.claude\skills\text-to-visual`
  - Generate matching visuals from text via Picsart gen-ai.

- **ui-ux-pro-max** — `C:\Users\admin\.claude\skills\ui-ux-pro-max`
  - Design intelligence for UI/UX generation and critique; use for layouts, typography, color palettes, tokens, and UX best practices. 50 styles, 21 palettes, 50 font pairings, 20 charts, 9 stacks (React, Next.js, Vue, Svelt

- **using-godot-prompter** — `C:\Users\admin\.claude\skills\using-godot-prompter`
  - Bootstrap skill — establishes how to find and use GodotPrompter skills, with platform-specific tool mapping

- **ux-design** — `C:\Users\admin\.claude\skills\ux-design`
  - Guided, section-by-section UX spec authoring for a screen, flow, or HUD. Reads game concept, player journey, and relevant GDDs to provide context-aware design guidance. Produces ux-spec.md (per screen/flow) or hud-design

- **ux-design-standards** — `C:\Users\admin\.claude\skills\ux-design-standards`
  - UX design principles for agent-console. Use when designing features, evaluating acceptance criteria, or reviewing user-facing interactions in a multi-agent management UI.

- **ux-review** — `C:\Users\admin\.claude\skills\ux-review`
  - Validates a UX spec, HUD design, or interaction pattern library for completeness, accessibility compliance, GDD alignment, and implementation readiness. Produces APPROVED / NEEDS REVISION / MAJOR REVISION NEEDED verdict 

- **verifying-turn-based-games** — `C:\Users\admin\.claude\skills\verifying-turn-based-games`
  - Verifies two-player strict-alternating-turn games via a pure-function engine contract and bot-ladder / WP-tension metrics. Use when designing or implementing board/card games that need replay, search, bot ladders, win-ra

- **vertical-slice** — `C:\Users\admin\.claude\skills\vertical-slice`
  - Pre-Production validation — build a production-quality end-to-end build to confirm the full game loop is achievable before committing to Production. Run after GDDs, architecture, and UX specs are complete. Produces a PRO

- **very-long-text-summarization** — `C:\Users\admin\.claude\skills\very-long-text-summarization`
  - Summarizes very long texts (books, handbooks, biographies, codebases) using hierarchical multi-pass extraction with cheap model armies. Produces structured knowledge maps, not just summaries.

- **video-motion-graphics** — `C:\Users\admin\.claude\skills\video-motion-graphics`
  - Use when creating After Effects compositions, Premiere Pro motion, video titles, explainer videos, or broadcast motion graphics.

- **web-artifacts-builder** — `C:\Users\admin\.claude\skills\web-artifacts-builder`
  - Suite of tools for creating elaborate, multi-component claude.ai HTML artifacts using modern frontend web technologies (React, Tailwind CSS, shadcn/ui). Use for complex artifacts requiring state management, routing, or s

- **web-search** — `C:\Users\admin\.claude\skills\web-search`
  - Formulate effective web search queries, analyze search results, and synthesize findings. Optimize search strategies for different types of information needs.

- **win31-audio-design** — `C:\Users\admin\.claude\skills\win31-audio-design`
  - Expert in Windows 3.1 era sound vocabulary for modern web/mobile apps. Creates satisfying retro UI sounds using CC-licensed 8-bit audio, Web Audio API, and haptic coordination. Activate on

- **win31-pixel-art-designer** — `C:\Users\admin\.claude\skills\win31-pixel-art-designer`
  - Expert in Windows 3.1 era pixel art and graphics. Creates icons, banners, splash screens, and UI assets with authentic 16/256-color palettes, dithering patterns, and Program Manager styling.

- **windows-3-1-web-designer** — `C:\Users\admin\.claude\skills\windows-3-1-web-designer`
  - Modern web applications with authentic Windows 3.1 aesthetic. Solid navy title bars, Program Manager navigation, beveled borders, single window controls. Extrapolates Win31 to AI chatbots (Cue

- **windows-95-web-designer** — `C:\Users\admin\.claude\skills\windows-95-web-designer`
  - Modern web applications with authentic Windows 95 aesthetic. Gradient title bars, Start menu paradigm, taskbar patterns, 3D beveled chrome. Extrapolates Win95 to AI chatbots, mobile UIs, responsive

- **xlsx** — `C:\Users\admin\.claude\skills\xlsx`
  - Comprehensive spreadsheet creation, editing, and analysis with support for formulas, formatting, data analysis, and visualization. When Claude needs to work with spreadsheets (.xlsx, .xlsm, .csv, .tsv, etc) for: (1) Crea

- **xlsx-manipulation** — `C:\Users\admin\.claude\skills\xlsx-manipulation`
  - Create, edit, and manipulate Excel spreadsheets programmatically using openpyxl

- **deep-research** — `C:\Users\admin\.cursor\skills\deep-research`
  - Use when the user explicitly asks for deep research / 深度研究 / 深入调研, or when they need evidence-driven, multi-source research for a decision, report, due diligence, current-state analysis, technical comparison, recommendat

---

## Suggested next steps

- **MCP:** Command Palette → `MCP: List Servers` (or this extension’s hub **MCP** tab) → start/trust servers in **Copilot Chat → Agent → tools**.
- **Edit config:** `MCP: Open Workspace Folder MCP Configuration` / `MCP: Open User Configuration`.
- **Refresh this report:** run **Intelligence — scan MCP & Skills awareness** again after changing `mcp.json` or adding skills.

_Report from GitHub Copilot Toolbox extension._

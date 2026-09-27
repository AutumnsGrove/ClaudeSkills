# Claude Skills Library

A comprehensive collection of 16 production-ready Claude Skills covering document manipulation, testing, database management, API design, DevOps, code quality, and communication workflows.

## 📋 Guides & Resources

- **[SKILL_CREATION_GUIDE.md](./SKILL_CREATION_GUIDE.md)** - Comprehensive guide for creating high-quality Claude Skills (1,247 lines)
- **[SKILL_BUILDER_SUBAGENT.md](./SKILL_BUILDER_SUBAGENT.md)** - Magic prompt for spawning specialized skill-building agents

## 📚 Skills Overview

### Document Manipulation (3 skills)
| Skill | Description | Files |
|-------|-------------|-------|
| **[xlsx](./xlsx/)** | Excel spreadsheet creation, editing, and analysis with formulas, charts, and data manipulation | SKILL.md + 3 Python scripts |
| **[pptx](./pptx/)** | PowerPoint presentation creation with layouts, charts, and professional formatting | SKILL.md + Python helper |
| **[pdf](./pdf/)** | PDF manipulation including text extraction, form filling, merging, and creation | SKILL.md + Python helper |

### Development & Testing (4 skills)
| Skill | Description | Files |
|-------|-------------|-------|
| **[webapp-testing](./webapp-testing/)** | Playwright-based web application testing with multi-browser support | SKILL.md + 2 Python scripts |
| **[mcp-builder](./mcp-builder/)** | Guide for building Model Context Protocol (MCP) servers | SKILL.md + 3 examples |
| **[d3js-visualization](./d3js-visualization/)** | Data visualization with D3.js for interactive charts and dashboards | SKILL.md + scripts + 3 examples |
| **[api-designer](./api-designer/)** | REST/GraphQL API design with OpenAPI 3.0 specs and authentication patterns | SKILL.md + Python helper + examples |

### Database & Backend (1 skill)
| Skill | Description | Files |
|-------|-------------|-------|
| **[sql-expert](./sql-expert/)** | SQL query writing, optimization, and database schema design for PostgreSQL, MySQL, SQLite | SKILL.md + Python helper + 2,690 lines SQL examples |

### DevOps & Infrastructure (2 skills)
| Skill | Description | Files |
|-------|-------------|-------|
| **[docker-workflow](./docker-workflow/)** | Docker containerization with multi-stage builds, compose orchestration, and optimization | SKILL.md + Bash helper + examples |
| **[env-config](./env-config/)** | Environment variable management with UV integration, secrets handling, and multi-env support | SKILL.md + Python helper + examples |

### Code Quality & Debugging (3 skills)
| Skill | Description | Files |
|-------|-------------|-------|
| **[git-advanced](./git-advanced/)** | Advanced Git operations including rebasing, conflict resolution, and branch strategies | SKILL.md + Bash helper + guides |
| **[code-reviewer](./code-reviewer/)** | Automated code review with security scanning, quality metrics, and best practice enforcement | SKILL.md + Python helper + checklists |
| **[error-detective](./error-detective/)** | Systematic debugging with TRACE framework, stack trace analysis, and error pattern recognition | SKILL.md + Python helper + examples |

### Communication & Documentation (3 skills)
| Skill | Description | Files |
|-------|-------------|-------|
| **[brand-guidelines](./brand-guidelines/)** | Corporate brand consistency enforcement and style guide creation | SKILL.md + 3 templates |
| **[internal-comms](./internal-comms/)** | Internal communications templates for status reports and newsletters | SKILL.md + 4 templates |
| **[markdown-pro](./markdown-pro/)** | Professional documentation with README generation, changelog automation, and TOC generation | SKILL.md + Python helper + templates |

## 🚀 Quick Start

### Install as a Plugin Marketplace

This repository is a plugin marketplace (see [`.claude-plugin/marketplace.json`](./.claude-plugin/marketplace.json), mirrored at [`.github/plugin/marketplace.json`](./.github/plugin/marketplace.json) for GitHub Copilot tools), so any tool that supports the agent plugin marketplace standard can install the skills directly from GitHub.

The skills are grouped into plugins by category:

| Plugin | Skills |
|--------|--------|
| `document-skills` | xlsx, pptx, pdf |
| `development-skills` | webapp-testing, mcp-builder, d3js-visualization, api-designer |
| `database-skills` | sql-expert |
| `devops-skills` | docker-workflow, env-config |
| `code-quality-skills` | git-advanced, code-reviewer, error-detective |
| `communication-skills` | brand-guidelines, internal-comms, markdown-pro |

**Claude Code**

```bash
/plugin marketplace add AutumnsGrove/ClaudeSkills
/plugin install document-skills@claude-skills
```

Or run `/plugin` and browse the `claude-skills` marketplace to pick plugins interactively. The same commands work from the shell as `claude plugin marketplace add ...` and `claude plugin install ...`.

**VS Code (GitHub Copilot agent plugins)**

Add the repository to the `chat.plugins.marketplaces` setting, then install plugins from the Extensions view (search `@agentPlugins`):

```json
"chat.plugins.marketplaces": ["AutumnsGrove/ClaudeSkills"]
```

**GitHub Copilot CLI**

```bash
copilot plugin marketplace add AutumnsGrove/ClaudeSkills
copilot plugin install document-skills@claude-skills
```

**Pinning to validated releases**

Every push to `master` is validated, smoke-tested, and published to the `plugins` branch, which contains only the manifests and skill folders. To track that branch instead of `master`, append `#plugins` to the source, e.g. `/plugin marketplace add AutumnsGrove/ClaudeSkills#plugins` or `"AutumnsGrove/ClaudeSkills#plugins"` in VS Code.

**Maintaining the marketplace**

When you add, rename, or remove a skill, register its folder in exactly one plugin's `skills` list in `.claude-plugin/marketplace.json`, then run the same checks CI runs:

```bash
./scripts/check-plugin-marketplace.sh   # manifest matches the skill folders (bash + jq)
claude plugin validate .                # Claude Code plugin rules
./scripts/smoke-test-plugins.sh         # every plugin installs and registers its skills
```

GitHub Actions workflows in `.github/workflows/`:

| Workflow | Runs on | What it does |
|----------|---------|--------------|
| `check-plugin-marketplace.yml` | every PR and push to `master` | Runs the three checks above |
| `publish-plugin-marketplace.yml` | push to `master` | Builds, re-validates, and publishes the `plugins` branch |
| `sync-to-claude-plugins.yml` | push to `master` | Mirrors the plugins into a central marketplace repo and opens a PR there. Skipped until the `CLAUDE_PLUGINS_REPO` variable (and the `CLAUDE_PLUGINS_APP_ID` / `CLAUDE_PLUGINS_APP_PRIVATE_KEY` secrets for a GitHub App on that repo) are set; see the workflow header |

### Using Skills with Claude

1. **In Claude.ai or Claude Code**: Reference skills by name when working on related tasks
2. **Via API**: Include skill content in your system prompts for specialized capabilities
3. **As Reference**: Browse SKILL.md files for comprehensive documentation and examples

### Installation

Most skills require Python dependencies. Install them as needed:

```bash
# Excel (xlsx)
pip install openpyxl pandas xlsxwriter

# PowerPoint (pptx)
pip install python-pptx Pillow pandas

# PDF (pdf)
pip install pypdf pdfplumber reportlab PyMuPDF pdf2image pytesseract pillow

# Web Testing (webapp-testing)
pip install playwright pytest
playwright install

# MCP Builder (mcp-builder)
pip install mcp anthropic  # Python SDK for MCP

# D3.js Visualization (d3js-visualization)
# No installation needed - pure JavaScript, run examples in browser

# API Designer (api-designer)
pip install pydantic fastapi jsonschema pyyaml

# SQL Expert (sql-expert)
pip install sqlalchemy psycopg2-binary pymysql

# Docker Workflow (docker-workflow)
# Requires Docker installed - no Python dependencies

# Environment Config (env-config)
# Requires UV: curl -LsSf https://astral.sh/uv/install.sh | sh
pip install python-dotenv cryptography pydantic pydantic-settings

# Git Advanced (git-advanced)
# No dependencies - uses git CLI

# Code Reviewer (code-reviewer)
pip install bandit safety radon pylint black

# Error Detective (error-detective)
# No dependencies - includes built-in utilities

# Markdown Pro (markdown-pro)
pip install gitpython markdown
```

### Creating Zipped Skills for Distribution

To package all skills as individual .zip files for drag-and-drop installation into Claude Desktop:

```bash
# Create ZippedSkills directory and zip all skill folders automatically
mkdir -p ZippedSkills && for skill in */; do
  [[ "$skill" == "ZippedSkills/" ]] && continue
  skill_name="${skill%/}"
  (cd "$skill_name" && zip -r "../ZippedSkills/${skill_name}.zip" . -x "*.DS_Store" -x "__pycache__/*") && echo "✓ Zipped $skill_name"
done
```

This creates a `ZippedSkills/` folder containing individual .zip files for all skills, automatically detecting new skills as they're added.

## 📖 Skill Details

### Document Manipulation Skills

#### **xlsx** - Excel Spreadsheets
- Create workbooks with formulas (SUM, VLOOKUP, pivot tables)
- Format cells with colors, fonts, borders
- Generate charts (line, bar, pie, scatter)
- Data analysis with pandas integration
- **Helper Script**: `scripts/excel_helper.py` with 34 utility functions

#### **pptx** - PowerPoint Presentations
- Create presentations from scratch or templates
- Add slides with various layouts
- Insert charts, images, tables, shapes
- Apply consistent branding and themes
- **Helper Script**: `scripts/pptx_helper.py` with 16 presentation utilities

#### **pdf** - PDF Documents
- Extract text with layout preservation
- Parse tables from PDFs
- Merge, split, and rotate documents
- Fill forms and add watermarks
- Create PDFs with reportlab
- **Helper Script**: `scripts/pdf_helper.py` with 24 PDF operations

### Development & Testing Skills

#### **webapp-testing** - Playwright Testing
- Multi-browser testing (Chrome, Firefox, Safari)
- Page Object Model pattern
- API mocking and network interception
- Mobile device emulation
- Visual regression testing
- **Helper Scripts**: `playwright_helper.py` + 40+ test examples

#### **mcp-builder** - MCP Server Development
- Build custom MCP servers for Claude
- Implement tools, resources, and prompts
- Authentication and security patterns
- Integration with external APIs
- **Examples**: Simple, advanced, and resource-focused servers

#### **d3js-visualization** - Data Visualization
- Interactive charts with D3.js
- Line, bar, scatter, network graphs
- Responsive design patterns
- Real-time data updates
- **Templates**: Reusable chart components
- **Examples**: 3 complete interactive visualizations

### Communication & Branding Skills

#### **brand-guidelines** - Brand Consistency
- Create comprehensive brand style guides
- Color palette management with WCAG compliance
- Typography and logo usage guidelines
- Brand voice and tone frameworks
- **Templates**: Complete brand config files

#### **internal-comms** - Internal Communications
- Weekly/monthly status reports
- Company newsletters (HTML)
- All-hands announcements
- Team update formats
- **Templates**: 4 ready-to-use communication templates

## 🎯 Use Cases

### For Developers
- **Data Analysis**: Use `xlsx` to process spreadsheets programmatically
- **Testing Automation**: Use `webapp-testing` for E2E test suites
- **API Integration**: Use `mcp-builder` to connect external services to Claude
- **Visualization**: Use `d3js-visualization` for interactive dashboards

### For Product Managers
- **Reports**: Use `pptx` to generate quarterly business reviews
- **Documentation**: Use `pdf` to extract data from reports
- **Communication**: Use `internal-comms` for status updates

### For Designers & Marketers
- **Brand Management**: Use `brand-guidelines` to maintain consistency
- **Data Visualization**: Use `d3js-visualization` for infographics
- **Presentations**: Use `pptx` for client presentations

## 📁 Directory Structure

```
ClaudeSkills/
├── README.md                          # This file
├── .claude-plugin/
│   └── marketplace.json               # Plugin marketplace manifest
├── .github/
│   ├── plugin/marketplace.json        # Symlink to the manifest (Copilot tools)
│   └── workflows/                     # Marketplace check, publish, and sync
├── scripts/                           # Marketplace check, smoke test, publish
├── xlsx/
│   ├── SKILL.md                       # Comprehensive documentation
│   ├── scripts/
│   │   ├── excel_helper.py            # 34 utility functions
│   │   └── example_usage.py           # Working examples
│   └── README.md
├── pptx/
│   ├── SKILL.md
│   └── scripts/
│       └── pptx_helper.py             # 16 presentation utilities
├── pdf/
│   ├── SKILL.md
│   └── scripts/
│       └── pdf_helper.py              # 24 PDF operations
├── webapp-testing/
│   ├── SKILL.md
│   └── scripts/
│       ├── playwright_helper.py       # Test utilities
│       └── test_examples.py           # 40+ test cases
├── mcp-builder/
│   ├── SKILL.md
│   └── examples/
│       ├── simple-server.py           # Basic MCP server
│       ├── advanced-server.py         # Multi-feature server
│       └── resource-server.py         # Resource-focused server
├── brand-guidelines/
│   ├── SKILL.md
│   └── examples/
│       ├── brand-config.json          # Brand configuration
│       ├── color-palette.json         # Color system
│       └── style-guide-template.md    # Complete template
├── internal-comms/
│   ├── SKILL.md
│   └── examples/
│       ├── status-report-template.md
│       ├── newsletter-template.html
│       ├── announcement-template.md
│       └── team-update-template.md
└── d3js-visualization/
    ├── SKILL.md
    ├── scripts/
    │   ├── chart-templates.js         # Reusable charts
    │   └── data-helpers.js            # Data utilities
    └── examples/
        ├── line-chart.html
        ├── bar-chart.html
        └── network-graph.html
```

## 🔧 Helper Scripts

Each skill includes production-ready helper scripts:

### Python Scripts
- **xlsx**: `excel_helper.py` - Create, edit, format Excel files
- **pptx**: `pptx_helper.py` - Build presentations programmatically
- **pdf**: `pdf_helper.py` - Manipulate PDF documents
- **webapp-testing**: `playwright_helper.py` - Browser automation utilities

### JavaScript Scripts
- **d3js-visualization**: `chart-templates.js` - Reusable D3 charts
- **d3js-visualization**: `data-helpers.js` - Data transformation

### Templates
- **brand-guidelines**: JSON configs for brand systems
- **internal-comms**: Markdown/HTML communication templates
- **mcp-builder**: Complete Python MCP server examples

## 📊 Statistics

- **Total Lines of Documentation**: 16,717 lines across all SKILL.md files
- **Helper Functions**: 100+ utility functions across all skills
- **Code Examples**: 150+ working code examples
- **Templates**: 10+ ready-to-use templates
- **Test Cases**: 40+ Playwright test examples

## 🎓 Learning Path

1. **Start with Documents**: Try `xlsx`, `pptx`, or `pdf` for immediate productivity
2. **Add Testing**: Learn `webapp-testing` for quality assurance
3. **Build Tools**: Explore `mcp-builder` to extend Claude's capabilities
4. **Visualize Data**: Use `d3js-visualization` for interactive dashboards
5. **Standardize Communications**: Apply `internal-comms` and `brand-guidelines`

## 💡 Best Practices

1. **Read SKILL.md First**: Each skill has comprehensive documentation with examples
2. **Start Simple**: Use helper scripts for common operations
3. **Customize**: Adapt templates and examples to your specific needs
4. **Test Code**: All Python scripts include error handling - test before production
5. **Version Control**: Track changes to skill configurations and templates

## 🤝 Contributing

To add new skills or improve existing ones:

1. Follow the SKILL.md format (YAML frontmatter + comprehensive content)
2. Include helper scripts with type hints and docstrings
3. Provide working examples
4. Document common pitfalls and best practices
5. Test all code examples

## 📝 Skill Format

Each skill follows the official Anthropic skills format:

```yaml
---
name: skill-name
description: "Clear description of capabilities and use cases"
---

# Skill Name

## Core Capabilities
- Capability 1
- Capability 2

## Workflows
Step-by-step instructions...

## Examples
Working code examples...

## Best Practices
Recommendations...

## Common Pitfalls
Issues and solutions...
```

## 🔗 Resources

- [Official Anthropic Skills Repository](https://github.com/anthropics/skills)
- [Claude Documentation](https://docs.anthropic.com)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io)

## 📄 License

These skills are provided for demonstration and educational purposes. Individual libraries and tools used within skills may have their own licenses:
- openpyxl: MIT License
- python-pptx: MIT License
- pypdf/pdfplumber: BSD License
- Playwright: Apache 2.0
- D3.js: ISC License

---

**Ready to level up your Claude workflows?** Pick a skill and start building! 🚀

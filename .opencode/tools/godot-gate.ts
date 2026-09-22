import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Run one Getting Strange Godot verification gate (res://tests/*.gd or res://tools/*.gd) with the project log policy. Uses tools/run_gate.ps1, avoiding the @() array-binding pitfall of verify_scoped.ps1 via pwsh -File.",
  args: {
    script: tool.schema
      .string()
      .describe("Gate script res path, e.g. res://tests/smoke_test.gd"),
    tail: tool.schema
      .number()
      .optional()
      .describe("How many trailing output lines to return (default 60)"),
  },
  async execute(args, context) {
    const root = context.worktree || context.directory
    const proc = Bun.spawnSync(
      [
        "pwsh",
        "-NoProfile",
        "-File",
        `${root}/tools/run_gate.ps1`,
        "-Script",
        args.script,
        "-Tail",
        String(args.tail ?? 60),
      ],
      { cwd: root }
    )
    const out = proc.stdout.toString()
    const err = proc.stderr.toString()
    const clipped =
      out.length > 8000 ? "...[clipped]...\n" + out.slice(-8000) : out
    return `${clipped}\n${err ? "STDERR:\n" + err : ""}GATE_EXIT=${proc.exitCode}`
  },
})

---
id: deployments.rules.status
---
# Status marks
> Load when: showing the state of a job, build, deployment, package, session or any item that changes state.

| State | Mark (`.st.<class>`) | Word |
|---|---|---|
| Needs you | Solid accent dot, bold word | "needs you", "waiting" |
| Working | Solid light dot, slow pulse | "running", "building" |
| Queued / idle | Hollow ring | "queued", "idle" |
| Done / OK | Short dash | "done", "live", "200" |
| Failed | `✕` in danger text | "failed", "404" |
| Risk / full access | Square danger outline | "full access", "unsigned" |

- States differ by shape and lightness first. Hue is the third signal, never the only one.
- Every mark has a word next to it. A mark alone, a colored row or a colored cell is not a status.
- Use the same mark for the same state on every page of a project.
- The red family is for failures and risk only. "Needs you" is never red: red means broken, not "your turn".
- Animate only `working`, with a slow pulse that is off under reduced motion.
- Badges for categories (`stable`, `experimental`, `beginner`) are text with a 1px outline and no background. Experimental uses the danger outline.

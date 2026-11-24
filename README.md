# Concinnity Assets

Ready-made materials, props, skies, ground looks, particle effects, custom
shaders and a few showcase applications in `apps/`.

## Conventions

- **Ids are prefixed by kind** (`tex_`, `mat_`, `mesh_`, `prefab_`, `ground_`,
  `shader_`, and `env_` for an environment's clouds) so they rarely collide with
  an application's own. A `Sand` or `Dirt` look also declares `<id>_albedo` and
  `<id>_normal` textures. No two files declare the same id, so every kit and
  ground look can be included together, alongside one environment.
- **Prefabs stand on `y = 0` with their front facing `+Z`**, so a prefab placed
  at a point sits on the ground there, facing a camera that looks down `-Z`.
  Sizes are in meters.
- **Environments are exclusive.** Each declares the sun and sky, so an
  application includes one. The night environments note the exposure settings
  an application's `GraphicsConfig` needs to adapt to the dark.
- **Paths start at this repository's root**, which `.concinnity/` marks, so the
  kits name their files the same here and as a project's `assets/`.

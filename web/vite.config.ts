import { existsSync } from "node:fs"
import path from "node:path"
import { pathToFileURL } from "node:url"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

export default defineConfig(async () => {
    const themePlugin = [
        "../../kora_theme/vite-plugin.mjs",
        "../../../[standalone]/kora_theme/vite-plugin.mjs",
    ].map((candidate) => path.resolve(__dirname, candidate)).find((candidate) => existsSync(candidate))

    if (!themePlugin) throw new Error("Could not find the kora_theme Vite plugin")

    const { default: koraTheme } = await import(pathToFileURL(themePlugin).href)
    return {
        plugins: [koraTheme(), react()],
        base: "./",
        build: { outDir: "build" },
        resolve: { alias: { "@": path.resolve(__dirname, "./src") } },
    }
})

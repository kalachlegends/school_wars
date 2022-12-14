const esbuild = require('esbuild')
const esbuildSass = require("esbuild-sass-plugin")
const args = process.argv.slice(2)
const watch = args.includes('--watch')
const deploy = args.includes('--deploy')
const jquery = require("jquery")
const { globalExternals } = require("@fal-works/esbuild-plugin-global-externals");
//==========

const postcss = require('postcss')
const autoprefixer = require('autoprefixer')
const postcssPresetEnv = require('postcss-preset-env')
//=======SCSSS

const loader = {
    '.svg': 'file',
    '.scss': 'file',
    '.woff': 'file',
    '.woff2': 'file',
    '.eot': 'file',
    '.ttf': 'file',
}

const plugins = [
    // Add and configure plugins here
    esbuildSass.sassPlugin({
        async transform(source) {
            const { css } = await postcss([autoprefixer]).process(
                source
            );
            return css;
        },
    }),

]

let opts = {
    entryPoints: ['js/app.js', "scss/style.scss", "scss/home.scss"],
    bundle: true,
    target: 'es2017',
    outdir: '../priv/static/assets',
    logLevel: 'info',
    loader,
    plugins
}

if (watch) {
    opts = {
        ...opts,
        watch,
        sourcemap: 'inline'
    }
}

if (deploy) {
    opts = {
        ...opts,
        minify: true
    }
}

const promise = esbuild.build(opts)

if (watch) {
    promise.then(_result => {
        process.stdin.on('close', () => {
            process.exit(0)
        })

        process.stdin.resume()
    })
}
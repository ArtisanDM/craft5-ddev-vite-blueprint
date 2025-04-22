import liveReload from 'vite-plugin-live-reload';
import legacy from '@vitejs/plugin-legacy';
import critical from 'rollup-plugin-critical';
import viteCompression from 'vite-plugin-compression';

let port = 3000;

export default ({ command }) => ({
	base: command === 'serve' ? '' : '/dist/',
	css: { preprocessorOptions: { scss: { charset: false } } },
	build: {
		manifest: true,
		outDir: './web/dist/',
		rollupOptions: {
			input: {
				app: './src/js/app.ts',
				css: './src/sass/main.scss',
			},
		},
	},
	server: {
		host: '0.0.0.0',
		port: port,
		origin: `${process.env.DDEV_PRIMARY_URL.replace(/:\d+$/, '')}:3000`,
		// Configure CORS securely for the Vite dev server to allow requests from *.ddev.site domains,
		// supports additional hostnames (via regex). If you use another `project_tld`, adjust this.
		cors: {
			origin: /https?:\/\/([A-Za-z0-9\-\.]+)?(\.ddev\.site)(?::\d+)?$/,
		},
	},
	plugins: [
		liveReload(['./templates/**/*']),
		legacy({
			targets: ['defaults'],
			additionalLegacyPolyfills: ['regenerator-runtime/runtime'],
		}),
		critical({
			criticalUrl: 'http://localhost',
			criticalBase: './web/dist/criticalcss/',
			criticalPages: [{ uri: '/', template: 'index' }],
			criticalConfig: {},
		}),
		viteCompression(),
	],
});

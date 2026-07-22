import liveReloadPkg from 'vite-plugin-live-reload';
import viteCompression from 'vite-plugin-compression';
import vue from '@vitejs/plugin-vue';
import svgLoader from 'vite-svg-loader';
import { defineConfig } from 'vite';

const liveReload = liveReloadPkg.default ?? liveReloadPkg;

export default defineConfig(async ({ command }) => {
	const { default: critical } = await import('rollup-plugin-critical');
	return {
		base: command === 'serve' ? '' : '/dist/',
		css: { preprocessorOptions: { scss: { charset: false } } },
		build: {
			manifest: true,
			outDir: './web/dist/',
			rollupOptions: {
				input: {
					app: './src/js/app.ts',
					css: './src/scss/main.scss',
				},
			},
			target: ['es2020', 'safari14'],
		},
		server: {
			host: '0.0.0.0',
			port: port,
			origin: process.env.DDEV_PRIMARY_URL
				? `${process.env.DDEV_PRIMARY_URL.replace(/:\d+$/, '')}:3000`
				: undefined,
			cors: {
				origin: /https?:\/\/([A-Za-z0-9\-\.]+)?(\.ddev\.site)(?::\d+)?$/,
			},
		},
		resolve: {
			alias: {
				vue: 'vue/dist/vue.esm-bundler.js',
			},
		},
		plugins: [
			vue({
				template: {
					compilerOptions: {
						isCustomElement: (tag) => tag.startsWith('x-'),
					},
				},
			}),
			liveReload(['./templates/**/*']),
			critical({
				criticalUrl: 'http://localhost',
				criticalBase: './web/dist/criticalcss/',
				criticalPages: [{ uri: '/', template: 'index' }],
				criticalConfig: {},
			}),
			viteCompression(),
			svgLoader({
				svgoConfig: {
					plugins: [
						{
							name: 'preset-default',
							params: {
								overrides: {
									removeViewBox: false,
								},
							},
						},
					],
				},
			}),
		],
		optimizeDeps: {
			include: ['vue'],
		},
	};
});

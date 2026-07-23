import liveReloadPkg from 'vite-plugin-live-reload';
import viteCompression from 'vite-plugin-compression';
import vue from '@vitejs/plugin-vue';
import svgLoader from 'vite-svg-loader';
import { defineConfig } from 'vite';

const liveReload = liveReloadPkg.default ?? liveReloadPkg;

export default defineConfig(({ command }) => {
	return {
		base: command === 'serve' ? '' : '/dist/',
		css: { preprocessorOptions: { scss: { charset: false } } },
		build: {
			manifest: true,
			outDir: './web/dist/',
			target: ['es2020', 'safari14'],
			rolldownOptions: {
				input: {
					app: 'src/js/app.ts',
					css: 'src/scss/main.scss',
				},
				output: {
					entryFileNames: '[name].js',
					assetFileNames: '[name].[ext]',
				},
			},
		},
		server: {
			host: '0.0.0.0',
			port: 3000,
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

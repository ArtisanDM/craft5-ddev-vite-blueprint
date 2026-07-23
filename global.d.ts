/// <reference types="vite/client" />

export {};

declare module '*.svg' {
	import { DefineComponent } from 'vue';
	const component: DefineComponent<{}, {}, {}, {}, {}, {}, {}, {}, false>;
	export default component;
}

declare module '*.scss' {
	const content: string;
	export default content;
}

declare global {
	interface ImportMeta {
		glob: (
			pattern: string,
			options?: { eager?: boolean }
		) => Record<string, any>;
	}
}

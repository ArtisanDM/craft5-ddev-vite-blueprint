import fs from 'fs-extra';
import { fileURLToPath } from 'url';

const __dirname = fileURLToPath(new URL('.', import.meta.url));

fs.emptyDirSync(`${__dirname}/web/dist`);

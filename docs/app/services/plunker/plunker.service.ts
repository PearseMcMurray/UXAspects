import { Injectable, Inject } from '@angular/core';
import { DOCUMENT } from '@angular/platform-browser';

import { AppConfiguration } from '../app-configuration/app-configuration.service';
import { IPlunk } from '../../interfaces/IPlunk';

const ASSETS_URL_PLACEHOLDER_REGEX = /\$\{assetsUrl\}/g;
const MODULES_PLACEHOLDER = /\$\{modules\}/g;
const DECLARATIONS_PLACEHOLDER = /\$\{declarations\}/g;
const IMPORTS_PLACEHOLDER = /\$\{imports\}/g;
const MAPPINGS_PLACEHOLDER = /\$\{mappings\}/g;

@Injectable()
export class PlunkerService {

    private assetsUrl = this.appConfig.get('assetsUrl');
    private plunkerPostUrl = this.appConfig.get('plunker');

    constructor( @Inject(DOCUMENT) private document: Document, private appConfig: AppConfiguration) { }

    public launch(title: string, plunk: IPlunk) {

        const form = this.initForm(title, plunk);

        this.document.body.appendChild(form);

        form.submit();

        this.document.body.removeChild(form);
    }

    private initForm(title: string, plunk: IPlunk): HTMLFormElement {

        let modules = ['BrowserModule'];
        let declarations = ['AppComponent'];
        let imports: string[] = [];
        let mappings: string[] = [];

        if (plunk.modules) {

            // create list of declarations
            plunk.modules.filter(mapping => mapping.declaration).forEach(mapping => {
                if (mapping.imports instanceof Array) {
                    declarations = declarations.concat(mapping.imports);
                } else {
                    declarations.push(mapping.imports);
                }
            });

            // create list of module imports
            plunk.modules.filter(mapping => !mapping.declaration).forEach(mapping => {
                if (mapping.imports instanceof Array) {
                    modules = modules.concat(mapping.imports);
                } else {
                    modules.push(mapping.imports);
                }
            });

            // generate the import statements
            plunk.modules.forEach(mapping => {

                if (mapping.library) {

                    if (!mapping.imports) {
                        imports.push(`import '${mapping.library}';`);
                    } else if (mapping.imports instanceof Array) {
                        imports.push(`import { ${mapping.imports} } from '${mapping.library}';`);
                    } else if (mapping.importAs) {
                        imports.push(`import * as ${mapping.imports} from '${mapping.library}';`);
                    } else {
                        imports.push(`import ${mapping.imports} from '${mapping.library}';`);
                    }
                }
            });
        }

        // create the list of mappings for systemjs
        if (plunk.mappings) {
            mappings = plunk.mappings.map(mapping => `'${mapping.alias}': '${mapping.source}'`);
        }

        let indexHtml = require('./templates/index_html.txt')
            .replace(ASSETS_URL_PLACEHOLDER_REGEX, this.assetsUrl);

        let mainTs = require('./templates/main_ts.txt')
            .replace(MODULES_PLACEHOLDER, (modules.toString()))
            .replace(DECLARATIONS_PLACEHOLDER, (declarations.toString()))
            .replace(IMPORTS_PLACEHOLDER, imports.join('\n'));

        let configJs = require('./templates/config_js.txt')
            .replace(MAPPINGS_PLACEHOLDER, mappings.join(',\n\t\t\t\t'));

        const postData = {
            'description': title,
            'private': true,
            'files[index.html]': indexHtml,
            'files[config.js]': configJs,
            'files[src/main.ts]': mainTs
        };

        for (let key in plunk.files) {
            postData[`files[src/${key}]`] = plunk.files[key];
        }

        const form = this.document.createElement('form');

        form.action = this.plunkerPostUrl;
        form.method = 'POST';
        form.target = '_blank';

        for (let field in postData) {

            const input = this.document.createElement('input');

            input.type = 'hidden';
            input.name = field;
            input.value = postData[field];

            form.appendChild(input);
        }

        return form;
    }
}
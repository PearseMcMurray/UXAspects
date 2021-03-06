import { Component } from '@angular/core';
import { DocumentationSectionComponent } from '../../../../../decorators/documentation-section-component';
import { Facet, FacetEvent, FacetSelect, FacetDeselect, FacetDeselectAll } from '../../../../../../../src/index';
import { IPlunk } from '../../../../../interfaces/IPlunk';
import { IPlunkProvider } from '../../../../../interfaces/IPlunkProvider';
import 'chance';

@Component({
    selector: 'uxd-components-facet-check-list',
    templateUrl: './facet-check-list.component.html'
})
@DocumentationSectionComponent('ComponentsFacetCheckListComponent')
export class ComponentsFacetCheckListComponent implements IPlunkProvider {

    facets: Facet[] = [];
    event: string;

    htmlCode = require('./snippets/app.html');
    tsCode = require('./snippets/app.ts');

    plunk: IPlunk = {
        files: {
            'app.component.ts': require('./snippets/app.ts'),
            'app.component.html': require('./snippets/app.html')
        },
        mappings: [
            {
                alias: 'chance',
                source: 'npm:chance@1.0.6'
            }
        ],
        modules: [{
            imports: ['FacetsModule'],
            library: 'ux-aspects'
        }]
    };

    constructor() {

        // generate some facets
        for (let idx = 0; idx < 30; idx++) {
            this.facets.push(new Facet(chance.name(), null, chance.integer({ min: 0, max: 100})));
        }
    }

    onEvent(event: FacetEvent) {

        if (event instanceof FacetSelect) {
            this.event = `${ event.facet.title } was selected!`;
        }

        if (event instanceof FacetDeselect) {
            this.event = `${ event.facet.title } was deselected!`;
        }

        if (event instanceof FacetDeselectAll) {
            this.event = 'All facets were deselected!';
        }

    }
}
import { Component } from '@angular/core';
import { DocumentationSectionComponent } from '../../../../../decorators/documentation-section-component';
import { BaseDocumentationSection } from '../../../../../components/base-documentation-section/base-documentation-section';

@Component({
    selector: 'uxd-components-dynamic-filters',
    templateUrl: './dynamic-filters-ng1.component.html'
})
@DocumentationSectionComponent('ComponentsDynamicFiltersNg1Component')
export class ComponentsDynamicFiltersNg1Component extends BaseDocumentationSection {
    
    private filterContainerCode = this.snippets.compiled.filterContainerHtml;
    private filterControllerCode = this.snippets.compiled.filterContainerJs;
    private filterOptionsCode = this.snippets.compiled.filterOptionsJs;
    private filterCode = this.snippets.compiled.filterHtml;
    
    constructor() {
        super(
            null, // require.context('!!prismjs-loader?lang=html!./snippets/', false, /\.html$/),
            null, // require.context('!!prismjs-loader?lang=css!./snippets/', false, /\.css$/),
            null, // require.context('!!prismjs-loader?lang=javascript!./snippets/', false, /\.js$/),
            null, // require.context('!!prismjs-loader?lang=typescript!./snippets/', false, /\.ts$/),
            require.context('./snippets/', false, /\.(html|css|js|ts)$/)
        );
    }

}
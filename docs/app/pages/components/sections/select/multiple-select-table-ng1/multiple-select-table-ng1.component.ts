import { Component, ChangeDetectionStrategy } from '@angular/core';
import { DocumentationSectionComponent } from '../../../../../decorators/documentation-section-component';
import { ICodePenProvider } from '../../../../../interfaces/ICodePenProvider';
import { ICodePen } from '../../../../../interfaces/ICodePen';
import { BaseDocumentationSection } from '../../../../../components/base-documentation-section/base-documentation-section';

@Component({
    selector: 'uxd-components-multiple-select-table-ng1',
    templateUrl: './multiple-select-table-ng1.component.html',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
@DocumentationSectionComponent('ComponentsMultipleSelectTableNg1Component')
export class ComponentsMultipleSelectTableNg1Component extends BaseDocumentationSection implements ICodePenProvider {

    public codeSnippet = '{ id: 1, name: "Eric Carpenter" }';

    constructor() {
        super(
            null, // require.context('!!prismjs-loader?lang=html!./snippets/', false, /\.html$/),
            null, // require.context('!!prismjs-loader?lang=css!./snippets/', false, /\.css$/),
            null, // require.context('!!prismjs-loader?lang=javascript!./snippets/', false, /\.js$/),
            null, // require.context('!!prismjs-loader?lang=typescript!./snippets/', false, /\.ts$/),
            require.context('./snippets/', false, /\.(html|css|js|ts)$/)
        );
    }

    public codepen: ICodePen = {
        html: this.snippets.raw.sampleHtml,
        htmlAttributes: {
            'ng-controller': 'MultipleSelectTableCtrl as vm'
        },
        js: [this.snippets.raw.sampleFullJs]
    };

}
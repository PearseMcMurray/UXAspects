import { Injectable, Renderer2 } from '@angular/core';
import { Subject } from 'rxjs/Subject';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/observable/fromEvent';


@Injectable()
export class ResizeService {

    addResizeListener(nativeElement: HTMLElement, renderer: Renderer2): Subject<any> {

        // create subject
        let subject = new Subject<any>();

        // determine the style of the element
        let displayMode = window.getComputedStyle(nativeElement).getPropertyValue('display');

        // create the iframe element
        let iframe = renderer.createElement('iframe');

        // style the iframe to be invisible but fill containing element
        renderer.setStyle(iframe, 'position', 'absolute');
        renderer.setStyle(iframe, 'width', '100%');
        renderer.setStyle(iframe, 'height', '100%');
        renderer.setStyle(iframe, 'top', '0');
        renderer.setStyle(iframe, 'right', '0');
        renderer.setStyle(iframe, 'bottom', '0');
        renderer.setStyle(iframe, 'left', '0');
        renderer.setStyle(iframe, 'z-index', '-1');
        renderer.setStyle(iframe, 'opacity', '0');
        renderer.setStyle(iframe, 'border', 'none');
        renderer.setStyle(iframe, 'margin', '0');
        renderer.setStyle(iframe, 'pointer-events', 'none');
        renderer.setStyle(iframe, 'overflow', 'hidden');

        // ensure the iframe ignores any tabbing
        renderer.setAttribute(iframe, 'tabindex', '-1');

        // statically positioned elements need changed to relative for this method to work
        if (displayMode !== 'relative' && displayMode !== 'absolute' && displayMode !== 'fixed') {
            renderer.setStyle(nativeElement, 'position', 'relative');
        }

        // add the iframe to the container element
        renderer.appendChild(nativeElement, iframe);

        // wait for iframe to load
        iframe.addEventListener('load', () => {

            // now attach resize listener
            Observable.fromEvent(iframe.contentWindow, 'resize').subscribe((event: any) => {
                subject.next(event);
            });
        });

        return subject;
    }
}
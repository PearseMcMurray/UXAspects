import { Component } from '@angular/core';
import { ColorService } from 'ux-aspects';

@Component({
    selector: 'app',
    templateUrl: './src/app.component.html',
    styleUrls: ['./src/app.component.css']
})
export class AppComponent {

    // configure the directive data
    donutChartData: Chart.ChartData = [{
        data: [25, 15, 18, 20, 10],
        borderWidth: 0
    }];

    donutChartLabels: string[] = ['Sales 1', 'Sales 2', 'Sales 3', 'Sales 4', 'Sales 5'];
    donutChartOptions: Chart.ChartOptions;
    donutChartLegend: boolean = true;
    donutChartColors: any;

    constructor(colorService: ColorService) {

        let tooltipBackgroundColor = colorService.getColor('grey2').toHex();

        this.donutChartOptions = {
            maintainAspectRatio: false,
            responsive: true,
            cutoutPercentage: 70,
            legend: {
                position: 'right',
                labels: {
                    boxWidth: 12
                }
            },
            tooltips: {
                callbacks: {
                    title: (item: Chart.ChartTooltipItem[]) => {
                        return;
                    },
                    label: (item: Chart.ChartTooltipItem, data: any) => {

                        // get the dataset (we only have one)
                        let dataset = data.datasets[0];

                        // calculate the total of all segment values
                        let total = dataset.data.reduce((previousValue: any, currentValue: any) => {
                            return previousValue + currentValue;
                        });

                        // get the value of the current segment
                        let segmentValue = dataset.data[item.index];

                        // calculate the percentage of the current segment compared to the total
                        let precentage = Math.round(((segmentValue / total) * 100));

                        return `${ precentage }%, Sales ${ item.index + 1 }`;
                    }
                },
                backgroundColor: tooltipBackgroundColor,
                cornerRadius: 0,
                displayColors: false
            } as any
        };

        this.donutChartColors = [
            {
                backgroundColor: [
                    colorService.getColor('chart1').toRgb(),
                    colorService.getColor('chart2').toRgb(),
                    colorService.getColor('chart3').toRgb(),
                    colorService.getColor('chart4').toRgb(),
                    colorService.getColor('chart5').toRgb()
                ],
                hoverBackgroundColor: [
                    colorService.getColor('chart1').setAlpha(0.3).toRgba(),
                    colorService.getColor('chart2').setAlpha(0.3).toRgba(),
                    colorService.getColor('chart3').setAlpha(0.3).toRgba(),
                    colorService.getColor('chart4').setAlpha(0.3).toRgba(),
                    colorService.getColor('chart5').setAlpha(0.3).toRgba()
                ]
            }
        ];
    }

}
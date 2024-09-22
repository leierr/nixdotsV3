import { monitorFile, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export default function() {
    const directoryToMonitor = `${App.configDir}/style/sass`;
    const scssFilePath = `${App.configDir}/style/sass/main.scss`;
    const cssMainFilePath = `${App.configDir}/style/index.css`;

    execAsync(`sass --no-charset --no-source-map ${scssFilePath} ${cssMainFilePath}`)

    monitorFile(directoryToMonitor, function() {
        execAsync(`sass --no-charset --no-source-map ${scssFilePath} ${cssMainFilePath}`)
            .catch(err => print(err));

        App.resetCss()
        App.applyCss(cssMainFilePath);
    });
}
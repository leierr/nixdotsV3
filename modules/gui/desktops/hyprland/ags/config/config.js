import topbar from './widgets/topbar/topbar.js';
import auto_reapply_css from './modules/auto_reload_css.js'

auto_reapply_css()

App.config({
    windows: [
        ...topbar,
    ],
    style: `${App.configDir}/style/index.css`,
    iconTheme: 'Papirus-Dark'
})

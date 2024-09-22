import systray from './submodules/systray/systray.js'
import workspaces from './submodules/workspaces/workspaces.js'
import nixoslogo from './submodules/nixlogo/nixlogo.js'
import datetime from './submodules/datetime/datetime.js'
import battery from './submodules/battery/battery.js'
const hyprland = await Service.import('hyprland')

// layout of the bar
const Left = (items) => Widget.Box({
    vpack: 'center',
    hexpand: true,
    spacing: 8,
    children: items,
});

const Center = (items) => Widget.Box({
    vpack: 'center',
    spacing: 8,
    children: items,
});

const Right = (items) => Widget.Box({
    hpack: 'end',
    vpack: 'center',
    spacing: 8,
    children: items,
});

// list of bars per monitor in hyprland session
export default hyprland.monitors.map(mon =>
    Widget.Window({
        name: `bar-${mon.id}`, // name has to be unique
        className: 'topbar',
        monitor: mon.id,
        anchor: ['top', 'left', 'right'],
        exclusivity: 'exclusive',
        visible: true,
        child: Widget.CenterBox({
            className: 'topbar_centerbox',
            start_widget: Left([nixoslogo(), workspaces(mon)]),
            center_widget: Center([datetime()]),
            end_widget: Right([battery(), systray()]),
        }),
    })
);
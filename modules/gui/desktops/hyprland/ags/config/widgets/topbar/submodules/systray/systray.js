const systemtray = await Service.import('systemtray')

const systrayitem = item => Widget.EventBox({
    onPrimaryClick: (_, event) => {item.secondaryActivate(event)},
    onSecondaryClick: (_, event) => {item.openMenu(event)},
    child: Widget.Icon({
        class_name: 'systray_item',
        tooltipMarkup: item.bind('tooltip_markup'),
    }).bind('icon', item, 'icon'),
})

export default () => Widget.Box({
    class_name: 'systray_container',
    visible: false, // DEFAULT
    children: systemtray.bind('items').as(i => i.map(systrayitem))
})
.hook( systemtray, (self) => {
    if (systemtray.items.length === 0) {
        self.visible = false
    } else {
        self.visible = true
    }
})

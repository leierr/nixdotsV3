const battery = await Service.import('battery') 

export default () => {
    if ( battery.available ) {
        return Widget.Box({
            vertical: false,
            children: [
                Widget.Box({
                    class_name: 'battery_widget_box',
                    vertical: false,
                    children: [
                        Widget.Icon({
                            class_name: 'battery_widget_charging_icon',
                            icon: `${App.configDir}/assets/bolt.svg`,
                        }),
                        Widget.ProgressBar({
                            class_name: 'battery_widget_charging_progressbar',
                            vpack: "center",
                        }),
                    ],
                }),
                Widget.Box({
                    class_name: 'battery_widget_box',
                    vertical: false,
                    children: [
                        Widget.Icon({
                            class_name: 'battery_widget_non_charging_icon',
                        }),
                        Widget.Label({
                            class_name: 'battery_widget_non_charging_percentage',
                        }),
                    ],
                }),
            ],
        }).hook(battery, self => {
            const low_battery_icon = `${App.configDir}/assets/low_battery.svg`
            const mid_battery_icon = `${App.configDir}/assets/half_full_battery.svg`
            const full_battery_icon = `${App.configDir}/assets/full_battery.svg`
    
            if (battery.charging) {
                self.children[0].visible = true
                self.children[1].visible = false
            } else {
                self.children[0].visible = false
                self.children[1].visible = true
            }
        
            self.children[1].children[1].label = ((battery.percent / 100) || 0) + "%";
            
            if (battery.percent > 65) {
                self.children[1].children[0].icon = full_battery_icon
            } else if (battery.percent > 32) {
                self.children[1].children[0].icon = mid_battery_icon
            } else if (battery.percent < 33) {
                self.children[1].children[0].icon = low_battery_icon
            }
        
        }, "changed")
    }
}



import GLib from "gi://GLib"

const datetime = Variable(GLib.DateTime.new_now_local(), {
    poll: [1000, () => GLib.DateTime.new_now_local()],
})

export default () => Widget.Button({
    class_name: 'datetime_widget',
    label: datetime.bind().as(t => t.format("%b %e, %H:%M").replace(/\s{2,}/g, ' ')),
})
package power

import (
	"fmt"

	"github.com/rivo/tview"
	"github.com/wtfutil/wtf/view"
)

type Widget struct {
	view.TextWidget

	Battery *Battery

	settings *Settings
}

func NewWidget(app *tview.Application, settings *Settings) *Widget {
	widget := Widget{
		TextWidget: view.NewTextWidget(app, settings.common, false),

		Battery: NewBattery(),

		settings: settings,
	}

	widget.View.SetWrap(true)

	return &widget
}

func (widget *Widget) content() (string, string, bool) {
	content := fmt.Sprintf(" %10s: %s\n", "Source", powerSource())
	content += "\n"
	content += widget.Battery.String()
	return widget.CommonSettings().Title, content, true
}

func (widget *Widget) Refresh() {
	widget.Battery.Refresh()
	widget.RedrawFunc(widget.content)
}

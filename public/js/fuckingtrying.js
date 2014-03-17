(function ($) {


    if (!$.fn.tree) {
        throw "Error jqTree is not loaded.";
    }

    $.fn.jqtreeContextMenu = function (callbacks) {

        var self = this;
        var $el = this;


        // Disable system context menu from beeing displayed.
        $el.bind("contextmenu", function (e) {
            e.preventDefault();
            return false;
        });

        // Handle the contextmenu event sent from jqTree when user clicks right mouse button.
        $el.bind('tree.contextmenu', function (event) {

            // First we figure out what type of node we are dealing with (e.g., folder, file)
            var $menuEl = $('#'+event.node.type);

            var x = event.click_event.pageX;
            var y = event.click_event.pageY;
            var yPadding = 5;
            var xPadding = 5;
            var menuHeight = $menuEl.height();
            var menuWidth = $menuEl.width();
            var windowHeight = $(window).height();
            var windowWidth = $(window).width();

            if (menuHeight + y + yPadding > windowHeight) {
                // Make sure the whole menu is rendered within the viewport.
                y = y - menuHeight;
            }
            if (menuWidth + x + xPadding > windowWidth) {
                // Make sure the whole menu is rendered within the viewport.
                x = x - menuWidth;
            }

            // Must call show before we set the offset (offset can not be set on display: none elements).
            $menuEl.show();

            $menuEl.offset({ left: x, top: y });

            var dismissContextMenu = function () {
                $(document).unbind('click.jqtreecontextmenu');
                $el.unbind('tree.click.jqtreecontextmenu');
                $menuEl.hide();
            }

            // Make it possible to dismiss context menu by clicking somewhere in the document.
            $(document).bind('click.jqtreecontextmenu', function () {
                dismissContextMenu();
            });

            // Dismiss context menu if another node in the tree is clicked.
            $el.bind('tree.click.jqtreecontextmenu', function (e) {
                dismissContextMenu();
            });

            // Make selection follow the node that was right clicked on.
            var selectedNode = $el.tree('getSelectedNode');
            if (selectedNode !== event.node) {
                $el.tree('selectNode', event.node);
            }

            // Handle click on menu items, if it's not disabled.
            var menuItems = $menuEl.find('li:not(.disabled) a');
            if (menuItems.length !== 0) {
                menuItems.unbind('click');
                menuItems.click(function (e) {
                    e.stopImmediatePropagation();
                    dismissContextMenu();
                    var hrefAnchor = e.currentTarget.attributes.href.nodeValue;
                    var funcKey = hrefAnchor.slice(hrefAnchor.indexOf("#") + 1, hrefAnchor.length)
                    var callbackFn = callbacks[funcKey];
                    if (callbackFn) {
                        callbackFn(event.node);
                    }
                    return false;
                });
            }
        });

        return this;
    };
} (jQuery));
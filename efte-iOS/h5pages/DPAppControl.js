function DPAppControl (domNode) {
    this.domNode = domNode;
    this.init();
}

$.extend(DPAppControl.prototype, {
    init: function () {
        this._touchStartTime = 0;
        this._touch = null;

        this._longPressDelay = 1.5; // if user press more than {x}s, fire long press event;
        this._longPressTimer = null;
        this._longPressFired = false;

        $(this.domNode).addClass('DPAppControl');

        this.bindEvents();
    },

    bindEvents: function () {
        $(this.domNode).on('touchstart', $.proxy(this, 'onTouchStart'))
                    .on('touchend', $.proxy(this, 'onTouchEnd'))
                    .on('touchmove', $.proxy(this, 'onTouchMove'));

    },

    onTouchStart: function (evt) {
        this._touchStartTime = new Date().getTime();
        this._longPressFired = false;
        this._clearLongPressTimer();
        this._longPressTimer = setTimeout($.proxy(this, '_fireLongPress'), this._longPressDelay * 1000);
        this._startScrollTop = $(window).scrollTop();
        this._startScrollLeft = $(window).scrollLeft();
        this._scrolled = false;

        $(this.domNode).addClass('DPAppControl-highlight')

        // console.log(this.domNode, 'touchstart');
    },

    onTouchMove: function (evt) {
        this._clearLongPressTimer();

        var touch = evt.touches[0];
        if (touch) {
            this._touch = touch;
        }
        // console.log(this.domNode, evt);

        this._scrolled = true;
        $(this.domNode).removeClass('DPAppControl-highlight');
        /*
        var delta = 10;
        if (Math.abs($(window).scrollTop() - this._startScrollTop) > delta
            || Math.abs($(window).scrollLeft() - this._startScrollLeft) > delta) {
            this._scrolled = true;
        }
        */
    },

    onTouchEnd: function (evt) {
        this._clearLongPressTimer();
        if (this._longPressFired) return ;
        var touchInside = !this._touch || this._inRect({x: this._touch.pageX, y: this._touch.pageY}, $(this.domNode).offset());
        $(this.domNode).removeClass('DPAppControl-highlight');

        this._touch = null;
        if (!this._scrolled) {
            touchInside ? this.onClick() : this.onTouchUpOutside();
        }
        // console.log(this.domNode, this._touch, touchInside);
    },

    onClick: function () {

    },

    onTouchUpOutside: function () {

    },

    onLongPress: function () {

    },

    dispatchEvent: function (type, canBubble, cancelable /* ... */) {
        // @see https://developer.mozilla.org/en-US/docs/Web/API/event.initMouseEvent
        var evt = document.createEvent("MouseEvents");
        evt.initMouseEvent.apply(evt, Array.prototype.slice.call(arguments));
        this.domNode.dispatchEvent(evt);
    },

    _fireLongPress: function() {
        $(this.domNode).removeClass('DPAppControl-highlight');
        this._longPressFired = true;
        this.onLongPress();
    },

    _clearLongPressTimer: function () {
        if (this._longPressTimer != null) {
            clearTimeout(this._longPressTimer);
            this._longPressTimer = null;
        }
    },

    _inRect: function (point, rect) {
        return rect.left <= point.x && point.x <= rect.left + rect.width
            && rect.top <= point.y && point.y <= rect.top + rect.height;
    },


    emptyFn: function () {
    }
});

////////////////////////////////////////////////////////////
/* Loading */
function DPLoading() {}

$.extend(DPLoading.prototype, {
    domNode: null,    
    _init: function() {
        var div = document.createElement('div');
        $(div).addClass('main_loading');

        var maskerDiv = document.createElement('div');
        $(maskerDiv).addClass('main_loading_masker');

        var activitorDiv = document.createElement('div');
        $(activitorDiv).addClass('main_loading_activitor');

        div.appendChild(maskerDiv);
        maskerDiv.appendChild(activitorDiv);

        this.domNode = div;

        $(this.domNode).on('touchstart', function(evt) {
            evt.preventDefault();
        });
    },  
    layoutSubViews: function () {
        var masker = $(this.domNode).children('.main_loading_masker');
        var activitor = masker.children('.main_loading_activitor');
        masker.css('margin-top', parseInt(($(this.domNode).height() - masker.height()) / 2) + 'px');
        // activitor.css('margin-top', parseInt((masker.height() - activitor.height()) / 2) + 'px');
    },
    show: function() {
        if (this.domNode == null) {
            this._init();
        }
        document.body.appendChild(this.domNode);
        this.layoutSubViews();
    },
    hide: function () {
        this.domNode.parentNode.removeChild(this.domNode);
    }

});



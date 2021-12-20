class Button extends React.Component {

    constructor(props) {
        super(props)
    }

    updateToolTip() {
        if(this.props.title){
            const anchor = $('a#' + this.props.id)
            anchor.tooltip({title: function(){ return $(this).attr('data-title') } })
        }
    }

    componentDidMount() {
        this.updateToolTip()
    }

    componentDidUpdate(){
        this.updateToolTip()
    }

    render() {
        const {
            id,
            href,
            title,
            dataToggle,
            dataPlacement,
            dataHtml,
            dataConfirm,
            rel,
            className,
            label,
            labelText,
            onClick,
        } = this.props;

        return (<button id={id}
                        href={href}
                        data-title={title}
                        data-toggle={dataToggle}
                        data-placement={dataPlacement}
                        data-html={dataHtml}
                        data-confirm={dataConfirm}
                        onClick={onClick}
                        rel={rel}
                        className={className}>{label}{labelText}</button>)
    }
}
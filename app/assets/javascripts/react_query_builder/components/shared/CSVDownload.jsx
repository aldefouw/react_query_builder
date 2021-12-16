class CSVDownload extends React.Component {

	constructor(props) {
		super(props);
		this.state={};
	}

	buildURI() {
		return buildURI(...arguments);
	}

	componentDidMount(){
		const {data, headers, separator, enclosingCharacter, uFEFF, target, specs, replace} = this.props;
		this.state.page = window.open(
			this.buildURI(data, uFEFF, headers, separator, enclosingCharacter), target, specs, replace
		);
	}

	getWindow() {
		return this.state.page;
	}

	render(){
		return (null)
	}
}
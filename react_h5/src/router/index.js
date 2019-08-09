import React, { Component } from "react";
import { BrowserRouter as Router, Route, Link, IndexRoute } from "react-router-dom";

class App extends Component {
    render() {
        return (
            <div>
                <h1>App</h1>
                <ul>
                    <li><Link to="/about">About</Link></li>
                    <li><Link to="/inbox">Inbox</Link></li>
                    <li><Link to="/messages/5">Message</Link></li>
                </ul>
                {this.props.children}
            </div>
        )
    }
}

class About extends Component {
    render() {
        return <h3>About</h3>
    }
}

class Inbox extends Component {
    render() {
        return (
            <div>
                <h2>Inbox</h2>
                {this.props.children || "Welcome to your Inbox"}
            </div>
        )
    }
}

class Message extends Component {

    render() {
        return <h3>Message {this.props.id}</h3>
    }
}

const RoutesInfo = [{
    path: '/App',
    component: App
}, {
    path: '/about',
    component: About
}, {
    path: '/inbox',
    component: Inbox
}, {
    path: '/messages/:id',
    component: Message
}]

const AppRouter = () => {
    return (
        <Router>
            {RoutesInfo.map((item, index) => {
                return (<Route path={item.path} component={item.component}></Route>)
            })}
        </Router>
    );
};



export default AppRouter;
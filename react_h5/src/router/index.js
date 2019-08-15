import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import { App } from "../pages/appPages/index"

const RoutesInfo = [{
    path: '/App',
    component: App
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
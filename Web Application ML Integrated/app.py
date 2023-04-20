import dash
from dash import Dash, html
# import dash_core_components as dcc
# import dash_html_components as html
import pandas as pd
import numpy as np
from dash.dependencies import Input, Output, State
import base64
import io
from dash import dash_table
from dash import dcc, html, Input, Output, State, callback_context, no_update
import dash_bootstrap_components as dbc
import plotly.express as px
import plotly.graph_objects as go
from pathlib import Path
import emoji
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error

deg = 2

app = Dash(__name__, external_stylesheets=[dbc.themes.SOLAR, dbc.icons.BOOTSTRAP])
# server = app.server

app.layout = dbc.Container([
    dbc.Card([
        dbc.CardBody(
            [
            dbc.Row(
            dbc.Col(
                [
                    html.H2(
                        emoji.emojize(":flashlight:") + " Analysis Of Channel Models For VLC " + emoji.emojize(":dizzy:"),
                        style={"textAlign": "center"},
                    ),
                    html.Hr(),
                ],
                # width=4,
            ),
            justify="center",
            ),
            ]),
    ]
    ),

    html.Br(),

    dbc.Card([ 
                dbc.CardBody(
            [ 
                    dbc.Container(
            [
                dbc.Row(
                dbc.Col(
                    [
                    html.H3("Upload Dataset  "+emoji.emojize(':package:'), className="app-header"),
                    html.P("Add your dataset here. Then we will guide through \
                                dataset modification tools where you can manipulate your dataset. ",className="body"),  
                    ]
                    #width=6,
                   
                ), justify="left",
         ),
                dbc.Row(
                dcc.Upload(
                    id='upload-data',
                    children=html.Div([
                        'Drag and Drop or ',
                        html.A('Select Files')
                        ]),
                        style= {
                        'width': '100%',
                        'height': '60px',
                        'lineHeight': '60px',
                        'borderWidth': '1px',
                        'borderStyle': 'dashed',
                        'borderRadius': '5px',
                        'textAlign': 'center',
                        'margin': '10px'},
                        multiple = True
                    ),justify="left",
                    
                ),
                html.Br(),
                html.Hr(),
            ]

        ),
            ]
            )
            ]
            ),

    html.Br(),
    dbc.Card(
    [
        dbc.CardHeader("View Uploaded Data"),
        dbc.CardBody(
            [
                dbc.Row(
                    [
                    #  html.Div(id='output-data-upload'),  
                    # html.Button('Display Table', id='display-table-button', n_clicks=0),
                    html.Div(id='output-data-upload') 
                    ]
                )
            ]
        )
    ]
    ),
    
    # html.Hr(),
    html.Br(),

    dbc.Card(
        [
            dbc.CardHeader("Your Data Set"),
            dbc.CardBody(
                [
                    dbc.Row(
                        [
                            dbc.Col(
                                "Select the independent variable(x)",
                                width=3,
                            ),
                            dbc.Col(
                                dcc.Dropdown(
                                    id="user_independent",               
                                    style={"width": "100%"},
                                    options=[],
                                    value=None,
                                    # multi=True,
                                ),
                                # width=9,
                            ),                                
                        ]
                    ),
                    dbc.Row(
                        [
                            dbc.Col(
                                "Select the dependent variable(y)",
                                width=3,
                            ),
                            dbc.Col(
                                dcc.Dropdown(
                                    id="user_dependent",                                           
                                    style={"width": "100%"},
                                    options=[],
                                    # multi=True,
                                    value=None,
                                ),
                                # width=9,
                            ),
                        ],
                        style={"margin-top": "10px", 'display': 'flex'},
                    ),html.Br(),
                    dbc.Row(
                        [
                            dbc.Col(
                                dbc.Button(
                                    "Run Model",
                                    id="train-button",
                                    color="success",
                                    style={"margin-left": "10px"},
                                ), 
                            ),

                        ]
                    ),html.Br(),

                    dbc.Row(
                    [
                        html.Div(id='train-score') 
                    ]
                ),

                ],
            ),
        ],
            style={
                "padding": "10px",
                "margin": "10px",
                "border-color": "#b2beb5",
            },
    ),
    dbc.Card(
                [
                    dbc.CardHeader("Visualized Graph"),
                    dbc.CardBody(
                        [ 
                            dbc.Row(
                                                # id="datac_graph",
                                                dcc.Graph(id='scatter-plot')
                               
                            ),
                            html.Br(),

                            dbc.Row(
                            [
                                html.Div(id='coef-value') 
                            ]
                            ),
                        ]
                        ),
                    
                ],
                 style={
                        "padding": "10px",
                        "margin": "10px",
                        "border-color": "#b2beb5",
                    },
            ),

    dbc.Card(
                [
                    dbc.CardHeader("Predict Values"),
                    dbc.CardBody(
                        [ 
                            dbc.Row(
                        [
                            dbc.Col(
                                "Enter value to predict",
                                width=3,
                                # dcc.Input(id='input-x', type='number', placeholder='Enter X value'),
                                # dbc.Button(
                                #     "Predict",
                                #     id="predict-button",
                                #     color="primary",
                                #     style={"margin-left": "10px"},
                                # ), 
                            ),

                            dbc.Col(
                                dcc.Input(id='input-x', type='number', placeholder='Enter X value'),
                            ),

                        ]
                    ),html.Br(),
                            dbc.Row(
                                [
                                    dbc.Col(
                                        dbc.Button(
                                            "Predict",
                                            id="predict-button",
                                            color="success",
                                            style={"margin-left": "10px"},
                                        ), 
                                    ),

                                ]
                            ),
                        html.Br(),
                            dbc.Row(
                                [
                                    html.Div(id='predict-value')
                                ]
                            ),

                        ]
                        ),
                    
                ],
                 style={
                        "padding": "10px",
                        "margin": "10px",
                        "border-color": "#b2beb5",
                    },
            ),


    
])

def parse_contents(contents, filename):
    content_type, content_string = contents.split(',')
    decoded = base64.b64decode(content_string)
    try:
        if 'csv' in filename:
            # Assume that the user uploaded a CSV file
            df = pd.read_csv(io.StringIO(decoded.decode('utf-8')))
        elif 'xls' in filename:
            # Assume that the user uploaded an excel file
            df = pd.read_excel(io.BytesIO(decoded))
    except Exception as e:
        print(e)
        return html.Div([
            'There was an error processing this file.'
        ])

    return [{'label': i, 'value': i} for i in df.columns], [{'label': i, 'value': i} for i in df.columns]

    # return html.Div([
    #     html.H5(filename),
    #     dash_table.DataTable(
    #         data=df.to_dict('records'),
    #         columns=[{'name': i, 'id': i} for i in df.columns]
    #     )
    # ])

@app.callback(
        Output('output-data-upload', 'children'),
        Output("user_independent", "options"),
        Output("user_dependent", "options"),
        # Input('display-table-button', 'n_clicks'),
        Input('upload-data', 'contents'),
        State('upload-data', 'filename'),       
        )
# def update_output(contents, filename):
#     if contents is not None:
#         columns1, columns2 = parse_contents(contents[0], filename[0])
#         children = [
#             parse_contents(contents[0], filename[0])
#         ]
#         return children, columns1, columns2
#     # if contents is not None:
#     #     children = [
#     #         parse_contents(contents[0], filename[0])
#     #     ]
#     #     return children

def update_output(contents, filename):
    # if n_clicks == 0:
    #     return html.Div('')
    
    if contents is not None:
        content_list = []
        options_list_1 = []
        options_list_2 = []
        for content, name in zip(contents, filename):
            options_1, options_2 = parse_contents(content, name)
            options_list_1 += options_1
            options_list_2 += options_2
            content_type, content_string = content.split(',')
            decoded = base64.b64decode(content_string)
            try:
                if 'csv' in name:
                    # Assume that the user uploaded a CSV file
                    df = pd.read_csv(io.StringIO(decoded.decode('utf-8')))
                elif 'xls' in name:
                    # Assume that the user uploaded an excel file
                    df = pd.read_excel(io.BytesIO(decoded))
                content_list.append(
                    dash_table.DataTable(
                        data=df.to_dict('records'),
                        columns=[{'name': i, 'id': i} for i in df.columns]
                    )
                )
            except Exception as e:
                print(e)
                return html.Div([
                    'There was an error processing this file.'
                ])
        return content_list, options_list_1, options_list_2
        # return options_list_1, options_list_2
    else:
        return None, [], []
        # return [], []

# Define the callback function for the "Train" button
@app.callback(
    [Output('train-score', 'children'),Output('scatter-plot', 'figure')],
    [Input('train-button', 'n_clicks')],
    [State('user_independent', 'value'), State('user_dependent', 'value'), State('upload-data', 'contents')]
)
def train_model(n_clicks, x_column, y_column, contents):
    
    if x_column is None or y_column is None:
    # No columns selected
        return 'Please select both X and Y columns.', {}

    if n_clicks == 0:
        # No button clicks yet
        return 'Please click the button.', {}

    if contents is None or len(contents) == 0:
        # No file uploaded
        return 'Please upload a CSV file.', {}

    # Read the uploaded file into a DataFrame
    content_type, content_string = contents[0].split(',')
    decoded = base64.b64decode(content_string)
    try:
        df = pd.read_csv(io.StringIO(decoded.decode('utf-8')))
    except Exception as e:
        print(e)
        return 'There was an error processing the CSV file.', {}

    # Make sure the selected columns exist in the DataFrame
    if x_column not in df.columns or y_column not in df.columns:
        return 'Please select valid X and Y columns.', {}

    # Create X and y arrays for training the model
    X = df[x_column].values.reshape(-1, 1)
    y = df[y_column].values.reshape(-1, 1)

    # x_train,x_test,y_train,y_test=train_test_split(X,y,test_size=0.2,random_state=0)
    # poly_reg1 = PolynomialFeatures(degree=2)
    # X_poly1 = poly_reg1.fit_transform(x_train)
    # lin_reg1 = LinearRegression()
    # lin_reg1.fit(X_poly1, y_train)

    # x_pred1 = poly_reg1.fit_transform(x_test)
    # y_pred1 = lin_reg1.predict(x_pred1)

    # print(np.sqrt(mean_squared_error(y_test,y_pred1)))

    # Train the model with polynomial regression
    poly_reg = PolynomialFeatures(degree=deg)
    X_poly = poly_reg.fit_transform(X)
    lin_reg = LinearRegression()
    lin_reg.fit(X_poly, y)
    x1=df[x_column].values
    y1=df[y_column].values
    con = np.polyfit(x1,y1,deg)
    print(f'Equation is ({con[0]:.2f})x^2 + ({con[1]:.2f})x + ({con[2]:.2f})')
    # Calculate the R-squared score of the model
    train_score = lin_reg.score(X_poly, y)

    # Generate the scatter plot of the data and the fitted curve
    x_range = np.linspace(X.min(), X.max(), 100).reshape(-1, 1)
    x_range_poly = poly_reg.fit_transform(x_range)
    y_pred = lin_reg.predict(x_range_poly)
    scatter_plot = {
        'data': [
            {'x': df[x_column], 'y': df[y_column], 'type': 'scatter', 'mode': 'markers', 'name': 'Data'},
            {'x': x_range.reshape(-1), 'y': y_pred.reshape(-1), 'type': 'scatter', 'mode': 'lines', 'name': 'Fitted Curve'},
        ],
        'layout': {'title': f'{y_column} vs {x_column}', 'xaxis': {'title': x_column}, 'yaxis': {'title': y_column}},
    }

    return f'Train score: {train_score:.4f}', scatter_plot

@app.callback(
    Output('predict-value', 'children'),
    [Input('predict-button', 'n_clicks')],
    [State('user_independent', 'value'), State('user_dependent', 'value'), State('upload-data', 'contents'), State('input-x', 'value')]
)
def predict_value(n_clicks, x_column, y_column,contents,input_x):
    if n_clicks is None:
        # No button clicks yet
        return ''

    if x_column is None or y_column is None:
        # No columns selected
        return 'Please select both X and Y columns.'

    if input_x is None:
        # No X value entered
        return 'Please enter a value for X.'

    if contents is None or len(contents) == 0:
        # No file uploaded
        return 'Please upload a CSV file.', {}

    # Read the uploaded file into a DataFrame
    content_type, content_string = contents[0].split(',')
    decoded = base64.b64decode(content_string)
    try:
        df = pd.read_csv(io.StringIO(decoded.decode('utf-8')))
    except Exception as e:
        print(e)
        return 'There was an error processing the CSV file.', {}

    # Make sure the selected columns exist in the DataFrame
    if x_column not in df.columns or y_column not in df.columns:
        return 'Please select valid X and Y columns.', {}

    # Prepare the data for prediction
    X_pred = [[input_x]]
    poly = PolynomialFeatures(degree=deg)
    X_pred_poly = poly.fit_transform(X_pred)

    # Train the model
    X = df[x_column].values.reshape(-1, 1)
    y = df[y_column].values.reshape(-1, 1)
    poly = PolynomialFeatures(degree=deg)
    X_poly = poly.fit_transform(X)
    model = LinearRegression()
    model.fit(X_poly, y)

    # Predict the value
    y_pred = model.predict(X_pred_poly)

    # Return the predicted value
    return f'Predicted value for {x_column} equals to {input_x} is {y_pred[0][0]:.4f}'


# def remove_used(list, used):
#     if used is not None:
#         list_cpy = list.copy()
#         for u in used:
#             if u in list:
#                 list_cpy.remove(u)
#         return list_cpy
#     else:
#         return list

# def errorBanner(error):
#     return error + emoji.emojize(":cross_mark:")

# app.layout=dbc.Container(card)
if __name__ == '__main__':
    app.run_server(debug=True)


# https://dash-bootstrap-components.opensource.faculty.ai/docs/themes/explorer/
import flask
import duckdb
from flask import render_template

app = flask.Flask(__name__, template_folder='templates', static_folder='templates/static')

@app.route("/")
def home():
    con = duckdb.connect("data/mcad.duckdb")
    
    # Haal alle tables op
    tables = con.execute("SHOW TABLES").fetchall()
    table_names = [t[0] for t in tables]
    
    # Custom order voor weergave
    order_priority = {
        'incidents': 1,
        'victims': 2,
        'joined': 3,
        'filtered': 4,
        'aggregated': 5
    }
    table_names.sort(key=lambda x: order_priority.get(x, 999))
    con.close()
    
    return render_template("home.html", table_names=table_names)

@app.route("/table/<table_name>")
def show_table(table_name):
    con = duckdb.connect("data/mcad.duckdb")
    
    try:
        # Haal info uit gegeven table
        result = con.execute(f"SELECT * FROM {table_name}")
        columns = [desc[0] for desc in result.description]
        data = result.fetchall()
        con.close()
        return render_template("table.html", table_name=table_name, columns=columns, data=data)
    except Exception:
        # Error voor als gegeven table niet bestaat
        con.close()
        return f"Tabel '{table_name}' niet gevonden", 404

if __name__ == "__main__":
    app.run(debug=True)

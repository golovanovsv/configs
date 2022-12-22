## Run remote debug
ENTRYPOINT ["python3", "-m", "debugpy", "--listen", "0.0.0.0:5678", "-m"]

## F-Strings
f"{var:.3f}"
f"{var:>10i}"

# Voila Dashboard

Run Voila dashboard in a Docker container.

```bash
docker run -it -p 8866:8866 -v $(pwd):/home/jovyan/notebooks giswqs/leafmap:voila
```

Then open http://localhost:8866 in your browser.

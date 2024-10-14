# OnShape to Robot, dockerized

This project can be used to build a dockerized version of [onshape-to-robot](https://onshape-to-robot.readthedocs.io/en/latest/index.html).

## Building

```sh
docker build -t onshape/urdf-exporter .
```

## Usage

First create a `.env` file with the environment variables `ONSHAPE_ACCESS_KEY` and `ONSHAPE_SECRET_KEY`. These values
may be generated online via the [OnShape dev portal](https://dev-portal.onshape.com/keys).

You may then run the export via the below command:
```sh
docker run --env-file=.env -v $(pwd):/work --rm -it onshape/urdf-exporter <YOUR_ONSHAPE_DOCUMENT_URL>
```

If all goes well, this will create the `robot/` folder with all related files, and particularly the `robot/robot.urdf` file.
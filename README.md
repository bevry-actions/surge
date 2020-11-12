# bevry-action/surge

Once your tests succeed, use this action to deploy your commit, branch, and tag to [Surge](https://surge.sh).

This allows you to git ignore your outputs (e.g. build files, documentation, etc) such that their changes don't make your repository dirty, nor pollute your git history, while allowing you to leverage CDN to referfence your source code and outputs, for every commit, branch, and tag.

## Example

For instance, for the [ambi](https://github.com/bevry/ambi) project.

You can get the rendered documentation for:

-   the [`master` branch](https://github.com/bevry/ambi/tree/master) via

    > http://master.ambi.bevry.surge.sh/docs/globals.html

-   the [`v8.22.0`](https://github.com/bevry/ambi/releases/tag/v6.6.0) tag via:

    > http://v8.22.0.ambi.bevry.surge.sh/docs/globals.html

-   the [`0250e1ed2cbc01773e0974165d1c9469c922b271` commit](https://github.com/bevry/ambi/commit/0250e1ed2cbc01773e0974165d1c9469c922b271) via:
    > http://0250e1ed2cbc01773e0974165d1c9469c922b271.ambi.bevry.surge.sh/docs/globals.html

## Install

Make sure that the desired surge version you wish to use is installed locally:

```bash
npm install --save-dev surge
```

And add the following to your GitHub Action workflow after your tests have completed and you have built your compile targets/documentation.

```yaml
- uses: bevry-actions/surge@main
  with:
      surgeLogin: ${{secrets.SURGE_LOGIN}}
      surgeToken: ${{secrets.SURGE_TOKEN}}
```

## License

Public Domain via The Unlicense

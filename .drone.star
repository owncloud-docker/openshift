def main(ctx):
    return lint() + test() + rocketchat()

def lint():
    return [
        {
            "kind": "pipeline",
            "type": "docker",
            "name": "lint",
            "steps": [
                {
                    "name": "starlark-format",
                    "image": "docker.io/owncloudci/bazel-buildifier",
                    "commands": [
                        "buildifier -d -diff_command='diff -u' .drone.star",
                    ],
                },
                {
                    "name": "editorconfig-format",
                    "image": "docker.io/mstruebing/editorconfig-checker",
                },
            ],
            "depends_on": [],
            "trigger": {
                "ref": [
                    "refs/heads/master",
                    "refs/pull/**",
                ],
            },
        },
    ]

def test():
    return [
        {
            "kind": "pipeline",
            "type": "docker",
            "name": "test",
            "platform": {
                "os": "linux",
                "arch": "amd64",
            },
            "steps": [
                {
                    "name": "lint",
                    "image": "docker.io/owncloudci/alpine",
                    "commands": [
                        "yamllint owncloud-*.yml",
                    ],
                },
                {
                    "name": "link-check",
                    "image": "ghcr.io/tcort/markdown-link-check:stable",
                    "commands": [
                        "/src/markdown-link-check README.md",
                    ],
                },
            ],
            "depends_on": [
                "lint",
            ],
            "trigger": {
                "ref": [
                    "refs/heads/master",
                    "refs/tags/**",
                    "refs/pull/**",
                ],
            },
        },
    ]

def rocketchat():
    return [
        {
            "kind": "pipeline",
            "type": "docker",
            "name": "rocketchat",
            "platform": {
                "os": "linux",
                "arch": "amd64",
            },
            "clone": {
                "disable": True,
            },
            "steps": [
                {
                    "name": "notify",
                    "image": "docker.io/plugins/slack",
                    "failure": "ignore",
                    "settings": {
                        "webhook": {
                            "from_secret": "rocketchat_talk_webhook",
                        },
                        "channel": {
                            "from_secret": "rocketchat_talk_channel",
                        },
                    },
                },
            ],
            "depends_on": [
                "test",
            ],
            "trigger": {
                "ref": [
                    "refs/heads/master",
                    "refs/tags/**",
                ],
                "status": [
                    "changed",
                    "failure",
                ],
            },
        },
    ]

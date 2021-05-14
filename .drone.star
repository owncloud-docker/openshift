def main(ctx):
  return test() + rocketchat()

def test():
  return [{
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'test',
    'platform': {
      'os': 'linux',
      'arch': 'amd64'
    },
    'steps': [
      {
        'name': 'lint',
        'image': 'python:alpine',
        'commands': [
          'pip install -qq yamllint',
          'yamllint owncloud-*.yml',
        ],
      },
      {
        'name': 'link-check',
        'image': 'ghcr.io/tcort/markdown-link-check:stable',
        'commands': [
          '/src/markdown-link-check README.md',
        ],
      },
    ],
    'depends_on': [],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
        'refs/pull/**',
      ],
    },
  }]

def rocketchat():
  return [{
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'rocketchat',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'clone': {
      'disable': True,
    },
    'steps': [
      {
        'name': 'notify',
        'image': 'plugins/slack',
        'pull': 'always',
        'failure': 'ignore',
        'settings': {
          'webhook': {
            'from_secret': 'public_rocketchat',
          },
          'channel': 'docker',
        },
      },
    ],
    'depends_on': [
      'test'
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ],
      'status': [
        'changed',
        'failure',
      ],
    },
  }]

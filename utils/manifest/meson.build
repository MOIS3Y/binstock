project('manifest',
    version: '0.1.0',
    license: 'MIT',
    meson_version: '>=0.60.0',
    default_options: [
        'warning_level=2',
    ]
)

# Standard installation directories
bindir = get_option('bindir')
datadir = get_option('datadir')

install_data(
    files('src/manifest.sh'),
    install_dir: bindir,
    install_mode: 'rwxr-xr-x',
    rename: 'manifest'
)

install_man('data/man/man1/manifest.1')

if get_option('bash-completions')
    install_data(
        'data/completions/bash/manifest',
        install_dir: datadir / 'bash-completion' / 'completions'
    )
endif

if get_option('zsh-completions')
    install_data(
        'data/completions/zsh/_manifest', 
        install_dir: datadir / 'zsh' / 'site-functions'
    )
endif

if get_option('tests')
    bats = find_program('bats', required: false)
    if bats.found()
        tests_dir = join_paths(meson.source_root(), 'tests')
        test('Integration tests', bats, args: [tests_dir / 'integration.bats'])
    endif
endif

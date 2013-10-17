util = require 'util'
path = require 'path'
yeoman = require 'yeoman-generator'


module.exports = class AnsibleRoleGenerator extends yeoman.generators.Base

    constructor: (args, options, config) ->

        yeoman.generators.Base.apply(this, arguments)
        @pkg = JSON.parse(@readFileAsString(path.join(__dirname, '../package.json')))

    askFor: ->

        cb = @async()

        console.log(@yeoman)

        prompts = [
            name: 'roleName'
            message: "What's role's name?"
        ,
            type: 'confirm'
            name: 'isVarsRequired'
            message: 'Is vars directory required?'
            default: false
        ,
            type: 'confirm'
            name: 'isFilesRequired'
            message: 'Is files directory required?'
            default: false
        ,
            type: 'confirm'
            name: 'isTemplatesRequired'
            message: 'Is templates directory required?'
            default: false
        ,
            type: 'confirm'
            name: 'isHandlersRequired'
            message: 'Is handlers directory required?'
            default: false
        ,
            name: 'dirMode'
            message: "What's dir's mode?"
            default: (0o777 & (~process.umask())).toString(8)
        ]

        @prompt(prompts, (props) =>
            @roleDir = "roles/#{props.roleName}"
            @isVarsRequired = props.isVarsRequired
            @isFilesRequired = props.isFilesRequired
            @isTemplatesRequired = props.isTemplatesRequired
            @isHandlersRequired = props.isHandlersRequired
            @dirMode = parseInt(props.dirMode, 8)
            cb()
        )

    app: ->

        @mkdir('roles', @dirMode)
        @mkdir(@roleDir, @dirMode)

        makeDir = (dirName, isDefaultYmlRequired = true) =>
            dir = "#{@roleDir}/#{dirName}"
            @mkdir(dir, @dirMode)
            if isDefaultYmlRequired
                @write("#{dir}/main.yml", '')

        makeDir('tasks')
        makeDir('vars') if @isVarsRequired
        makeDir('files', false) if @isFilesRequired
        makeDir('templates', false) if @isTemplatesRequired
        makeDir('handlers') if @isHandlersRequired

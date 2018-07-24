import com.dslexample.Helpers
import com.dslexample.PipelineJobBuilder
import com.dslexample.UnsupportedPluginJobBuilder
import com.dslexample.VibratoCiJobBuilder
import javaposse.jobdsl.dsl.DslFactory


// assign some things to a helper class so it's accessible elsewhere
Helpers.readFileFromWorkspace = this.&readFileFromWorkspace
Helpers.out = out

// build a job for every repository in the Vibrato GitHub team
def jobBuilder = new VibratoCiJobBuilder()
jobBuilder.build((DslFactory) this)

// build a few pipeline jobs
def pipelinesJobBuilder = new PipelineJobBuilder()
pipelinesJobBuilder.build((DslFactory) this)

// build a job that uses a plugin that's not supported by the Job DSL plugin
def unsupportedPluginJobBuilder = new UnsupportedPluginJobBuilder()
unsupportedPluginJobBuilder.build((DslFactory) this)


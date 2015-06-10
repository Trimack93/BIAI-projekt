using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using RDotNet;
using RDotNet.NativeLibrary;
using System.Diagnostics;
using System.IO;


namespace Projekt_BIAI.Model
{
    class _REngine
    {
        /// <summary>
        /// Instancja silnika R
        /// </summary>
        private REngine engine;


        public void Initialize()
        {
            REngine.SetEnvironmentVariables();
            engine = REngine.GetInstance();
            engine.Initialize();

            // Zmienia workplace dla instancji R na wymienioną - do indywidualnych potrzeb
            engine.Evaluate("setwd(\"E:/Git/BIAI-projekt/Data\")");
            //engine.Evaluate("setwd(\"C:/Users/Trimack/Desktop/studia/BIAI/Projekt/BIAI-projekt/Data\")");   // sówka
            //engine.Evaluate("setwd(\"E:/GitHub/BIAI-projekt/Data\")");   // lapek

            launchScript("setup", false);

        }

        /// <summary>
        /// Odpala skrypt o podanej nazwie
        /// </summary>
        /// <param name="scriptName">Nazwa pliku (z rozszerszeniem .R lub bez)</param>
        /// <param name="hasArguments">Czy dołączamy jakieś argumenty wywołania</param>
        /// <param name="arg">Argumenty wywołania</param>
        /// <returns>-1 dla danych z pliku; dla własnoręcznych 0 jak złe zdjęcie, 1 jak dobre</returns>
        public int launchScript(string scriptName, bool hasArguments, params string[] arg)
        {
            try
            {
                if (engine != null)
                {
                    // Dodawanie argumentów (symulacja linii poleceń
                    if (hasArguments)
                    {
                        string arguments = arg[0].ToString();

                        for (int i = 1; i < arg.Length; i++)
                            arguments += ("," + arg[i].ToString());

                        engine.Evaluate("commandArgs <- function() c(" + arguments + ")");                        
                    }

                    if (scriptName.Contains(".R"))
                        engine.Evaluate("source('" + scriptName + "')");
                    else
                    {
                        engine.Evaluate("source('" + scriptName + ".R')");
                    }
                }

                if (scriptName.Contains("UserForest"))
                {
                    IntegerVector result = engine.GetSymbol("userResult").AsInteger();
                    return result[0];
                }

            }
            catch (EvaluationException)
            {
                throw new EvaluationException("Brak pliku");
            }
            return -1;
        }

        /// <summary>
        /// Zamyka instancję. Przed zamknięciem aplikacji zawsze zamykać instancję!
        /// </summary>
        public void DisposeEngine()
        {
            if (engine != null)
                engine.Dispose();
        }
        
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using Projekt_BIAI.Model;
using RDotNet;

namespace Projekt_BIAI
{
    public partial class MainWindow : Form
    {
        /// <summary>
        /// Nasza instancja silnika R - może przyjmować wyrażenia w języku R lub odpalać gotowe skrypty
        /// </summary>
        private _REngine RConnector;

        public MainWindow()
        {
            InitializeComponent();

            RConnector = new _REngine();

            RConnector.Initialize();
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                RConnector.launchScript("test");
            }
            catch (EvaluationException)
            {
                MessageBox.Show("Nie istnieje skrypt o zadanej nazwie!", "Błąd", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void MainWindow_FormClosed(object sender, FormClosedEventArgs e)
        {
            RConnector.DisposeEngine();
        }
    }
}

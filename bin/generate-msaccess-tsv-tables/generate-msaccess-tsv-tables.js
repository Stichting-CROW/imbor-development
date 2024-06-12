import fs from "fs";
import path from "path";
import MDBReader from "mdb-reader";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";
import { pathToFileURL } from "url";

/** Return the column header line */
function tsvForColumns(/** @type {string[]} */ columns) {
  return columns.join("\t") + "\n";
}

/** Return the data row line */
function tsvForRow(
  /** @type {Record<string , import('mdb-reader/lib/types/types').Value>} */ row,
  /** @type {string[]} */ columns
) {
  let rowResult = "";
  for (const i in columns) {
    rowResult += row[columns[i]];
    if (i != columns.length - 1) rowResult += "\t";
  }
  return rowResult + "\n";
}

/** Open database, create destination dir and TSV files therein */
function run(
  /** @type {string} */ outputDir,
  /** @type {string} */ databasePath
) {
  const reader = new MDBReader(fs.readFileSync(databasePath));
  if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

  for (const tableName of reader.getTableNames()) {
    const tableFile = path.join(outputDir, `${tableName}.tsv`); // contrary to this script's name, use TSV
    const table = reader.getTable(tableName);
    const columns = table.getColumnNames();

    let contents = tsvForColumns(columns);
    for (const row of table.getData()) {
      contents += tsvForRow(row, columns);
    }

    try {
      fs.writeFileSync(tableFile, contents, {
        encoding: "utf-8",
      });
    } catch (err) {
      console.error(`Could not write to ${tableFile}, due to: ${err}`);
    }
  }
}

/** Command line options */
async function cli() {
  const argv = await yargs(hideBin(process.argv))
    .option("database", {
      type: "string",
      desc: "Path to input database file",
    })
    .demandOption("database")
    .option("datadir", {
      type: "string",
      desc: "Path to output data directory",
    })
    .demandOption("datadir")
    .parse();

  run(path.join(path.resolve(argv.datadir), "tsv"), argv.database);
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) void cli();
